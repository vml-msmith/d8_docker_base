<?php

class Input {
  public $options;
  public $inputString;

  protected function setDefaultOptions() {
    $this->options = array(
    );
  }

  public function __construct($args) {
    $this->setDefaultOptions();

    $inOptions = TRUE;
    $inputString = "";

    foreach ($args as $val) {
      $val = trim($val);

      if (!$val || $val === 'php' || $val === '/var/scripts/linter.php') {
        continue;
      }

      if ($inOptions == TRUE && strpos($val, '--') === 0) {
        print_r(array("option: " . $val . "\n"));
      }
      else {
        $inOptions = FALSE;
        $inputString .= " " . $val;
      }
    }
    $this->inputString = trim($inputString);
  }
}

class FileList {
  public $files;

  public function __construct($string, $path) {
    $this->files['all'] = explode(' ', $string);
    $this->files['all'] = array_map(function($item) {
        return '/var/www/' . $item;
      }, $this->files['all']);

    $this->filterPhpFiles();
    $this->filterCssFiles();
    $this->filterJsFiles();
  }

  protected function filterPhpFiles() {
    $response = array_filter($this->files['all'],
                             function($item) {
                               return preg_match("/.\.(php|module|inc|install)/i", $item);
                             });
    $this->files['php'] = $response;
  }

  protected function filterCssFiles() {
    $response = array_filter($this->files['all'],
                             function($item) {
                             return preg_match("/.\.(css|scss|sass)/i", $item);
                             });
    $this->files['css'] = $response;
  }

  protected function filterJsFiles() {
    $response = array_filter($this->files['all'],
                             function($item) {
                             return preg_match("/.\.(js)/i", $item);
                             });
    $this->files['js'] = $response;
  }

}

class PrettyPrint {
  static public function p($val, $level = 0) {
    $spaces = '';
    for ($i = 0; $i < $level; ++$i) {
      $spaces .= ' ';
    }

    if (is_array($val)) {
      foreach ($val as $value) {
        echo $spaces . $value . "\n";
      }
    }
    else {
      echo $spaces . $val . "\n";
    }
  }

  static public function header($str) {
    echo "#########################################\n";
    echo "## " . $str . "\n";
    echo "#########################################\n";
  }

  static public function footer() {
    echo "\n\n";
  }
}

class PHPTester {
  protected function testSyntax($files) {
    $testResponse = array();

    PrettyPrint::header("Testing PHP Syntax");
    foreach ($files as $file) {
      $output = '';
      $response = 0;

      ob_start();
      $meh = exec("php -l -d display_errors=0 $file", $output, $response);
      ob_end_clean();

      if ($response !== 0) {
        echo "Detected PHP syntax errors in file: $file\n";
        PrettyPrint::p($output, 2);
        $testResponse[$file] = $file;
      }
    }

    PrettyPrint::footer();

    return $testResponse;
  }

  protected function testPhpCs($files) {

    $testResponse = array();

    PrettyPrint::header("Testing PHPCS: Standards");

    $output = '';
    $fileString = implode(' ', $files);

    $drupalStandards = '/root/.composer/vendor/drupal/coder/coder_sniffer/Drupal';
    exec("/root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcs --standard=$drupalStandards --encoding=utf8 -n -p $fileString", $output, $response);

    PrettyPrint::p($output);
    if ($response !== 0) {
      $testResponse['drupal'] = 'drupal';
    }

    PrettyPrint::header("Testing PHPCS: Best Practice");

    $output = '';
    $drupalStandards = '/root/.composer/vendor/drupal/coder/coder_sniffer/DrupalPractice';
    exec("/root/.composer/vendor/squizlabs/php_codesniffer/scripts/phpcs --standard=$drupalStandards --encoding=utf8 -n -p $fileString", $output, $response);

    PrettyPrint::p($output);
    if ($response !== 0) {
      $testResponse['bp'] = 'bp';
    }

    return array();
  }

  public static function test($files) {
    $response = array();
    $response += static::testSyntax($files);
    $response += static::testPhpCs($files);

    return $response;
  }
}

$input = new Input($argv);
$fileList = new FileList($input->inputString, '/var/www/');


$files = $fileList->files['all'];
$php = $fileList->files['php'];

$errors = array();
$errors += PHPTester::test($php);

exit (count($errors));
