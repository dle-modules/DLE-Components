<?php

/**
 * Доработанный под модули DLE класс конфига из Morfy
 *
 * This file is part of the Morfy.
 *
 * (c) Romanenko Sergey / Awilum <awilum@msn.com>
 * (c) Павел Белоусов / pafnuty <pafnuty10@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
class Config {
	/**
	 * An instance of the Plugins class
	 *
	 * @var object
	 * @access  protected
	 */
	protected static $instance = null;

	/**
	 * Config
	 *
	 * @var array
	 * @access  protected
	 */
	protected static $config = [];

	/**
	 * Constructor.
	 *
	 * @access  protected
	 *
	 * @param string $moduleName Название модуля
	 */
	protected function __construct($moduleName = '') {
		static::$config['dle']    = self::getDleConfig();
		static::$config['module'] = self::getModuleConfig($moduleName);
		static::$config['lang']   = self::getLang();
	}

	/**
	 * Получение конфига DLE
	 *
	 * @author  Павел Белоуосв <pafnuty10@gmail.com>
	 *
	 *  <code>
	 *      $config = Config::getDleConfig();
	 *  </code>
	 *
	 * @access  public
	 * @return array
	 */
	public static function getDleConfig() {

		include ENGINE_DIR . '/data/config.php';

		/** @var array $config */
		return $config;
	}

	/**
	 * Получение конфига модуля
	 * Файл должен содержать переменную $componentsConfig = []
	 *
	 * @author  Павел Белоуосв <pafnuty10@gmail.com>
	 *
	 *  <code>
	 *      $config = Config::getModuleConfig('mymodule');
	 *  </code>
	 *
	 * @access  public
	 *
	 * @param  string $moduleName Название модуля
	 *
	 * @return array
	 */
	public static function getModuleConfig($moduleName = '') {
		if ($moduleName !== '') {
			include ENGINE_DIR . '/data/' . $moduleName . '.php';

			/** @var array $componentsConfig */
			return $componentsConfig;
		}

		return [];

	}

	/**
	 * Получение языковых фраз модуля
	 * Файл должен содержать переменную $componentsLang = []
	 *
	 * @author  Павел Белоуосв <pafnuty10@gmail.com>
	 *
	 *  <code>
	 *      $config = Config::getLang();
	 *  </code>
	 *
	 * @access  public
	 * @return array
	 */
	public static function getLang() {

		include ENGINE_DIR . '/modules/components/admin/lang/ru.php';

		/** @var array $componentsLang */
		return $componentsLang;

	}

	/**
	 * Set new or update existing config variable
	 *
	 *  <code>
	 *      Config::set('dle.allow_cache', 1);
	 *  </code>
	 *
	 * @access public
	 *
	 * @param string $key   Key
	 * @param mixed  $value Value
	 */
	public static function set($key, $value) {
		Arr::set(static::$config, $key, $value);
	}

	/**
	 * Get config variable
	 *
	 *  <code>
	 *      Config::get('dle');
	 *      Config::get('dle.http_home_url');
	 *  </code>
	 *
	 * @access  public
	 *
	 * @param  string $key Key
	 *
	 * @return mixed
	 */
	public static function get($key) {
		return Arr::get(static::$config, $key);
	}

	/**
	 * Get config array
	 *
	 *  <code>
	 *      $config = Config::getConfig();
	 *  </code>
	 *
	 * @access  public
	 * @return array
	 */
	public static function getConfig() {
		return static::$config;
	}

	/**
	 * @param  string $moduleName
	 *
	 * @return bool
	 */
	public static function init($moduleName = '') {
		return !isset(self::$instance) and self::$instance = new Config($moduleName);
	}

	/**
	 * Initialize Config
	 *
	 *  <code>
	 *      Config::init();
	 *      Config::init('modulename');
	 *  </code>
	 *
	 * @access  public
	 */

	/**
	 * Protected clone method to enforce singleton behavior.
	 *
	 * @access  protected
	 */
	protected function __clone() {
		// Nothing here.
	}
}
