<?php
/*
=============================================================================
DLE-Components — Компоненты для DLE
=============================================================================
Автор:   ПафНутиЙ
URL:     http://pafnuty.name/
twitter: https://twitter.com/pafnuty_name
email:   pafnuty10@gmail.com
=============================================================================
 */

// Всякие обязательные штуки для ajax DLE
@error_reporting(E_ALL ^ E_WARNING ^ E_NOTICE);
@ini_set('display_errors', true);
@ini_set('html_errors', false);
@ini_set('error_reporting', E_ALL ^ E_WARNING ^ E_NOTICE);

define('DATALIFEENGINE', true);
define('ROOT_DIR', substr(dirname(__FILE__), 0, -23));
define('ENGINE_DIR', ROOT_DIR . '/engine');

/* Базовую проверку независимую от движка лучше проводить перед подключением файлов */
$id = (int) $_REQUEST['id'];
if ($id < 1 && $_REQUEST['action'] == 'edit') {
	die('error');
}

include ENGINE_DIR . '/data/config.php';
/** @var array $config */
if ($config['http_home_url'] == '') {
	$config['http_home_url'] = explode('engine/ajax/components/editfield.php', $_SERVER['PHP_SELF']);
	$config['http_home_url'] = reset($config['http_home_url']);
	$config['http_home_url'] = 'http://' . $_SERVER['HTTP_HOST'] . $config['http_home_url'];
}
require_once ENGINE_DIR . '/classes/mysql.php';
require_once ENGINE_DIR . '/data/dbconfig.php';
require_once ENGINE_DIR . '/modules/functions.php';
if ($config['version_id'] > 9.6) {
	dle_session();
} else {
	@session_start();
}

$user_group = get_vars("usergroup");
if (!$user_group) {
	$user_group = [];
	$db->query("SELECT * FROM " . USERPREFIX . "_usergroups ORDER BY id ASC");
	while ($row = $db->get_row()) {
		$user_group[$row['id']] = [];
		foreach ($row as $key => $value) {
			$user_group[$row['id']][$key] = stripslashes($value);
		}

	}
	set_vars("usergroup", $user_group);
	$db->free();
}

$is_logged = false;

require_once ENGINE_DIR . '/modules/sitelogin.php';

if (!$is_logged) {
	die('error');
}
if ($member_id['user_group'] != '1') {
	die('error');
}

/**
 * var array $cConfig
 */
include ENGINE_DIR . '/data/components_config.php';

require_once ENGINE_DIR . '/modules/components/SplClassLoader.php';

$loader = new SplClassLoader(null, ENGINE_DIR . '/modules/components/classes');

// $loader->debug = true;

$loader->register();

// Подрубаем основной класс
$main = new Main('components');

if (Config::get('module.debug')) {
	Debug::enabled(true);
}

// Подрубаем шаблонизатор

$arTplParams = [
	'templatePath' => ENGINE_DIR . '/modules/components/admin/template/',
	'auto_reload'  => true,
];

$main->getTemplater($arTplParams);

// Массив для данных, выводимых в шаблоне.
$arResult = [];

Arr::set($arResult, 'config', Config::getConfig());
Arr::set($arResult, 'theme', '/engine/modules/components/admin/template');

// Определяемся с шаблоном для отображения
$currentAction = (isset($_REQUEST['action'])) ? $_REQUEST['action'] : '';

if ($currentAction == '') {
	die('no action');
}

$currentTemplate = '/ajax/' . $currentAction;

$isPost = ($_SERVER['REQUEST_METHOD'] == 'POST') ? true : false;

// Добавляем все ключи массивов, возможных к выводу в шаблоне.
$arKeys = [];
foreach ($arResult as $key => $v) {
	$arKeys[] = $key;
}

switch ($currentAction) {
	case 'edit':
		$arField = $main->db->getRow(
			'SELECT f.*, t.description as field_type_description FROM ?n f LEFT JOIN ?n t ON (f.type=t.type) WHERE f.id=?i', 
			PREFIX . '_components_fields_list', 
			PREFIX . '_components_fields_types',
			$id
		);
		Arr::set($arResult, 'arField', $arField);

		break;
	
	default:
		die();
		break;
}

Arr::set($arResult, 'arResultVars', $arKeys);

unset($arKeys);


// Результат обработки шаблона
try {
	$main->tpl->display($currentTemplate . '.tpl', $arResult);
} catch (Exception $e) {
	echo '<div style="color: red;">' . $e->getMessage() . '</div>';
}

// Убираем сообщение из сессии.
$main->clearMessage();
