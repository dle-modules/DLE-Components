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

/**
 * @global array $member_id  Массив с информацией о авторизованном пользователе, включая всю его информацию из профиля.
 * @global array $user_group Информация о всех группах пользователей и их настройках.
 * @global array $lang       Массив содержащий текст из языкового пакета.
 */

if (!defined('DATALIFEENGINE') OR !defined('LOGGED_IN')) {
	die('Hacking attempt!');
}
if ($member_id['user_group'] != '1') {
	msg('error', $lang['index_denied'], $lang['index_denied']);
}

require_once ENGINE_DIR . '/modules/components/SplClassLoader.php';

$loader = new SplClassLoader(null, ENGINE_DIR . '/modules/components/classes');

// $loader->debug = true;

$loader->register();

$output = '';

// Подрубаем основной класс
$main = new Main('components');

if (Config::get('module.debug')) {
	// 
}

// Подрубаем шаблонизатор

$arTplParams = [
	'templatePath' => ENGINE_DIR . '/modules/components/admin/template/',
	'auto_reload'  => true,
];

$main->getTemplater($arTplParams);

// Массив для данных, выводимых в шаблоне.
$arResult = [];

// Текущая страница постраничной навигации, на основе $_GET['page']
$curPageNum = (isset($_GET['page']) && (int)$_GET['page'] > 0) ? (int)$_GET['page'] : false;

// $curPage = (!empty($_SERVER['HTTPS'])) ? "https://" . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'] : "http://" . $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'];

$CurrentPagerUrl = Url::removeQueryString(Url::getCurrent(), 'page');

$pagerConfig = [
	// 'total_items'    => 150, // определяем кол-во там, где это требуется и если есть - дёргаем сам класс (см ниже)
	'items_per_page'   => Config::get('module.perPage'),
	'style'            => Config::get('module.navStyle'),
	'current_page'     => $curPageNum,
	'query_string'     => 'page',
	'link_tag'         => '<a class="btn btn-pager" href="' . $CurrentPagerUrl . '&page=:link">:name</a>',
	'current_tag'      => '<span class="btn btn-pager active">:name</span>',
	'prev_tag'         => '<a href="' . $CurrentPagerUrl . '&page=:link" class="btn btn-pager prev">&lsaquo; назад</a>',
	'prev_text_tag'    => '<span class="btn btn-pager prev">&lsaquo; назад</span>',
	'next_tag'         => '<a href="' . $CurrentPagerUrl . '&page=:link" class="btn btn-pager next">вперёд &rsaquo;</a>',
	'next_text_tag'    => '<span class="btn btn-pager next">вперёд &rsaquo;</span>',
	'first_tag'        => '<a href="' . $CurrentPagerUrl . '&page=:link" class="btn btn-pager first">&laquo; в начало</a>',
	'last_tag'         => '<a href="' . $CurrentPagerUrl . '&page=:link" class="btn btn-pager last">в конец &raquo;</a>',
	'extended_pageof'  => 'Страница :current_page из :total_pages',
	'extended_itemsof' => 'Показаны вопросы :current_first_item &mdash; :current_last_item из :total_items',
];

// Добавлем базовые переменные.
Arr::set($arResult, 'config', Config::getConfig());
Arr::set($arResult, 'theme', '/engine/modules/components/admin/template');
Arr::set($arResult, 'home', $PHP_SELF . '?mod=components');
Arr::set($arResult, 'pagerConfig', $pagerConfig);
Arr::set($arResult, 'arUserGroups', $user_group);

// Определяемся с шаблоном для отображения
$currentPage = (isset($_REQUEST['action'])) ? $_GET['action'] : 'index';

$currentTemplate = '/pages/' . $currentPage;

$isPost = ($_SERVER['REQUEST_METHOD'] == 'POST') ? true : false;

$componentId   = $elementId = (isset($_GET['id'])) ? (int)$_GET['id'] : 0;
$componentName = (isset($_GET['componentname'])) ? trim($_GET['componentname']) : '';

switch ($currentPage) {
	case 'componentslist':
	case 'index':
		Arr::set($arResult, 'componentsList', $main->getComponentsList($curPageNum, Config::get('module.perPage')));

		break;

	case 'showcomponent':
		if ($componentId > 0) {
			$arComponent = $main->db->getRow('SELECT * FROM ?n WHERE id = ?i', PREFIX . '_components', $componentId);
			if (!$arComponent) {
				// Делаем редирект с сообщенем об ошибочной выборке
				$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Компонент с кодом <b>' . $componentId . '</b> не найден');
			}

			Arr::set($arResult, 'component', $arComponent);

			$componentList = $main->getComponentElements($arComponent['name'], $curPageNum, Config::get('module.perPage'));

			Arr::set($arResult, 'componentList', $componentList);

		} else {
			// Делаем редирект с сообщенем об ошибочной выборке
			$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Не задан ID компонента');
		}

		break;

	case 'showelement':

		if ($componentName != '' && $elementId > 0) {

			$arElement = $main->getElementById($componentName, $elementId);

			if (!$arElement['id']) {
				$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Элемент с кодом <b>' . $elementId . '</b> не найден');
			}

			Arr::set($arResult, 'element', $arElement);


		} else {
			// Делаем редирект с сообщенем об ошибочной выборке
			$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Некорректно задан ID элемента или имя компонента');
		}


		break;

	case 'editelement':
	case 'addelement':
		$isEdit = false;

		$component = $main->getComponentByName($componentName);


		// Массив для данных, отдаваемых в шаблон при отправке формы.
		$arElementPost = [
			'name'       => '',
			'sort_index' => '500',
			'image'      => '',
			'text'       => '',
			'error'      => false,
			'errors'     => [],
			'success'    => 0,
		];

		Arr::set($arResult, 'component', $component);


		break;

	case 'editcomponent':
	case 'addcomponent':

		$isEdit = false;

		// Массив для данных, отдаваемых в шаблон при отправке формы.
		$arComponentPost = [
			'name'         => '',
			'sort_index'   => '500',
			'read_access'  => '',
			'write_access' => '',
			'description'  => '',
			'error'        => false,
			'errors'       => [],
			'success'      => 0,
		];

		if ($_REQUEST['action'] == 'editcomponent' && isset($_REQUEST['id']) && (int)$_REQUEST['id'] > 0) {
			$isEdit = true;
			if ($componentId > 0) {
				$arComponent = $main->db->getRow('SELECT * FROM ?n WHERE id = ?i', PREFIX . '_components', $componentId);
				if (!$arComponent) {
					// Делаем редирект с сообщенем об ошибочной выборке
					$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Компонент с ID <b>' . $componentId . '</b> не найден');
				}

				$arComponentPost = [
					'id'           => $arComponent['id'],
					'name'         => $arComponent['name'],
					'sort_index'   => $arComponent['sort_index'],
					'read_access'  => $arComponent['read_access'],
					'write_access' => $arComponent['write_access'],
					'description'  => $arComponent['description'],
					'error'        => false,
					'errors'       => [],
					'success'      => 0,
				];
			}
		} elseif ($_REQUEST['action'] == 'editcomponent') {
			// Делаем редирект с сообщенем об успешном добавлении компонента
			$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Некорректно задан ID компонента');
		}

		$selectegReadGroups  = (isset($_POST['read_access'])) ? $_POST['read_access']
			: ((isset($arComponentPost['read_access'])) ? explode(',', $arComponentPost['read_access']) : []);
		$selectegWriteGroups = (isset($_POST['write_access'])) ? $_POST['write_access']
			: ((isset($arComponentPost['write_access'])) ? explode(',', $arComponentPost['write_access']) : []);

		$arComponentPost['read_access']  = implode(',', $selectegReadGroups);
		$arComponentPost['write_access'] = implode(',', $selectegWriteGroups);

		Arr::set($arResult, 'selectedReadGroups', $selectegReadGroups);
		Arr::set($arResult, 'selectedWriteGroups', $selectegWriteGroups);

		if ($isPost) {
			/** @var array $arComponent */
			$postName = ($isEdit) ? $arComponent['name'] : '';

			// Обрабатываем название компонента
			if (isset($_POST['name']) && strlen(trim($_POST['name'])) > 0) {
				$postName = $main->leffersFilter($_POST['name']);
			}
			if (strlen($postName) == 0) {
				$arComponentPost['error']          = true;
				$arComponentPost['errors']['name'] = 'Не задано название компонента';
			} else {
				if (!$isPost) {
					$arExistComponent = $main->db->getOne('SELECT id FROM ?n WHERE name = ?s', PREFIX . '_components', $postName);
					if ($arExistComponent) {
						$arComponentPost['error']          = true;
						$arComponentPost['errors']['main'] = 'Компонент с таким именем уже существует';
					}
				}
			}

			$arComponentPost['name'] = $postName;

			if (isset($_POST['sort_index']) && (int)$_POST['sort_index'] > 0) {
				$arComponentPost['sort_index'] = (int)$_POST['sort_index'];
			}

			if (isset($_POST['description']) && strlen(trim($_POST['description'])) > 0) {
				$arComponentPost['description'] = htmlspecialchars(strip_tags(trim($_POST['description'])));
			}

			if (!$arComponentPost['error']) {

				if ($isEdit) {
					// Формируем запрос на обновление компонента
					$editComponentQuery = 'UPDATE ?n SET sort_index = ?i, read_access = ?s, write_access = ?s, description = ?s WHERE id = ?i';
					$main->db->query($editComponentQuery, PREFIX . '_components', $arComponentPost['sort_index'], $arComponentPost['read_access'], $arComponentPost['write_access'], $arComponentPost['description'], $arComponent['id']);

					// Очищаем кеш
					clear_cache();

					// Делаем редирект с сообщенем об успешном добавлении компонента
					$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'success', 'Компонент <b>' . $arComponent['name'] . '</b> успешно изменён.');
				} else {
					// Формируем запрос на создание компонента
					$addComponentQuery = 'INSERT INTO ?n (name, sort_index, read_access, write_access, description) values(?s, ?i, ?s, ?s, ?s)';
					$main->db->query($addComponentQuery, PREFIX . '_components', $arComponentPost['name'], $arComponentPost['sort_index'], $arComponentPost['read_access'], $arComponentPost['write_access'], $arComponentPost['description']);

					// Создаём таблицу для данных компонента
					$main->addComponentTable($postName);

					// Очищаем кеш
					clear_cache();

					// Делаем редирект с сообщенем об успешном добавлении компонента
					$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'success', 'Компонент <b>' . $postName . '</b> успешно создан.');
				}

			}

		}

		Arr::set($arResult, 'component', $arComponentPost);

		break;

	case 'editcomponentfields':
		$arComponent = $main->db->getRow('SELECT * FROM ?n WHERE id = ?i', PREFIX . '_components', $componentId);
		if (!$arComponent) {
			// Делаем редирект с сообщенем об ошибочной выборке
			$main->redirect(Arr::get($arResult, 'home') . '&action=componentslist', 'error', 'Компонент с кодом <b>' . $componentId . '</b> не найден');
		}
		// Массив с данными о компоненте
		Arr::set($arResult, 'component', $arComponent);

		// Получаем информацию о плях, используемых компонентом.
		Arr::set($arResult, 'fieldsList', $main->getComponentFieldsList($arComponent['id']));

		// Получаем все типы полей, имеющиеся в БД.
		Arr::set($arResult, 'fieldsTypes', $main->getFieldsTypes());

		break;

	case 'config':
		Arr::set($arResult, 'arConfig', Config::get('module'));

		break;

	default:
		// code...
		break;
}

/**
 * Добавляем все ключи массивов, возможных к выводу в шаблоне.
 */
$arTplVars = [];
foreach ($arResult as $key => $tplVar) {
	if (is_array($tplVar)) {
		foreach ($tplVar as $k => $v) {
			if (is_array($v)) {
				foreach ($v as $k_ => $v_) {
					$arTplVars[$key][$k][$k_] = $k_;
				}
			} else {
				$arTplVars[$key][$k] = $k;
			}
		}
	} else {
		$arTplVars[$key] = $key;
	}
}


Arr::set($arResult, 'arTplVars', $arTplVars);

unset($arTplVars);


// Результат обработки шаблона
try {
	$main->tpl->display($currentTemplate . '.tpl', $arResult);
} catch (Exception $e) {
	echo '<div style="color: red;">' . $e->getMessage() . '</div>';
}

// Убираем сообщение из сессии. 
$main->clearMessage();