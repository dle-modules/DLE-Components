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

$currentTemplate = '/ajax/fields/' . $currentAction;

$isPost = ($_SERVER['REQUEST_METHOD'] == 'POST') ? true : false;


switch ($currentAction) {
	case 'edit':
	case 'add':

		// Добавление нового допполя
		
		$componentId = (isset($_REQUEST['componentid'])) ? (int) $_REQUEST['componentid'] : 0;

		// Получаем данные указанного компонента
		$arComponent = $main->db->getRow('SELECT id, name FROM ?n WHERE id = ?i', PREFIX . '_components', $componentId);

		// Выведем ошибку, если компонент не найден
		if ($arComponent['id'] <= 0) {
			Arr::set($arResult, 'error', true);
			Arr::set($arResult, 'errors.componentid', 'ID компонента не указан, или указан несуществующий компонент');
		} else {
			Arr::set($arResult, 'component', $arComponent);
		}

		$arField = $_REQUEST;

		if ($currentAction == 'edit') {
			$arSelectField = $main->db->getRow(
				'SELECT * FROM ?n WHERE component_id = ?i AND id=?i',
				PREFIX . '_components_fields_list',
				$arComponent['id'],
				$id
			);
			switch ($arSelectField['type']) {
				case 'LIST':
				case 'CHK':
				case 'RAD':
				case 'CID':
					$arSelectField['default_value'] = json_decode($arSelectField['default_value'], true);
					break;
			}
		}

		if (!$isPost && $currentAction == 'edit') {
			$arField = $arSelectField;
		}
		if ($isPost && $currentAction == 'edit') {
			$arField['code'] = $arSelectField['code'];
			$arField['type'] = $arSelectField['type'];
		}
		

		// Получаем все типы полей, имеющиеся в БД.
		$arFieldsTypes = $main->getFieldsTypes();
		Arr::set($arResult, 'fieldsTypes', $arFieldsTypes);

		if (!isset($arFieldsTypes[$arField['type']])) {
			Arr::set($arResult, 'error', true);
			Arr::set($arResult, 'errors.fieldsTypes', 'Указан несуществующий тип поля');
		}

		// Фильтруем код поля для занесения в БД
		$arField['code'] = $main->leffersFilter($arField['code']);

		// Выведем ошибку, если код поля некорректен
		if ($arField['code'] == '' && (isset($arField['complete']))) {
			Arr::set($arResult, 'error', true);
			Arr::set($arResult, 'errors.code', 'Код допполя не указан или содержит недопустимые символы');
		}

		$isFieldExists = $main->db->getOne('SELECT id FROM ?n WHERE component_id = ?i AND code = ?s', PREFIX . '_components_fields_list', $arComponent['id'], $arField['code']);

		if ($isFieldExists && $currentAction == 'add') {
			Arr::set($arResult, 'error', true);
			Arr::set($arResult, 'errors.code', 'Дополнительное поле с таким кодом уже существует в этом компоненте');
		}

		// Запишем массив для передачи в шаблонизатор
		Arr::set($arResult, 'arField', $arField);
		
		Arr::set($arResult, 'complete', false);

		// Если ошибок нет — запишем даные в БД
		if (isset($arField['complete']) && !Arr::get($arResult, 'error')) {


			$defaultValue = $main->parseDefaulFieldValue($arField['default_value'], $arField['type']);

			$arFieldData = [
				'component_id'  => $arComponent['id'],
				'type'          => $arField['type'],
				'name'          => $arField['name'],
				'code'          => $arField['code'],
				'description'   => $arField['description'],
				'is_required'   => (isset($arField['is_required'])) ? 1 : 0,
				'is_multiple'   => (isset($arField['is_multiple'])) ? 1 : 0,
				'default_value' => $defaultValue,
			];
			if ($currentAction == 'edit') {
				$editFieldQuery = 'UPDATE ?n SET name = ?s, description = ?s, is_required = ?s, is_multiple = ?s, default_value = ?p WHERE component_id = ?i AND id = ?i';

				$main->db->query(
					$editFieldQuery, 
					PREFIX . '_components_fields_list', 
					$arFieldData['name'], 
					$arFieldData['description'], 
					$arFieldData['is_required'], 
					$arFieldData['is_multiple'], 
					$arFieldData['default_value'],
					$arFieldData['component_id'],
					$arSelectField['id']
				);

			} else {
				$addFieldQuery = 'INSERT INTO ?n (component_id, type, name, code, description, is_required, is_multiple, default_value) values(?i, ?s, ?s, ?s, ?s, ?i, ?i, ?p)';
				$main->db->query(
					$addFieldQuery, 
					PREFIX . '_components_fields_list', 
					$arFieldData['component_id'], 
					$arFieldData['type'], 
					$arFieldData['name'], 
					$arFieldData['code'], 
					$arFieldData['description'], 
					$arFieldData['is_required'], 
					$arFieldData['is_multiple'], 
					$arFieldData['default_value']
				);
			}
			

			Arr::set($arResult, 'complete', true);
		}


		break;

	default:
		die('no action');
		break;
}

// Добавляем все ключи массивов, возможных к выводу в шаблоне.
$arKeys = [];
foreach ($arResult as $key => $v) {
	$arKeys[] = $key;
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
