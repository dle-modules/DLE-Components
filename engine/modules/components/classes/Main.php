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
 * Основной класс
 * @property Fenom tpl
 */
class Main {

	public $db;

	/**
	 * Main constructor.
	 *
	 * @param string $moduleName
	 */
	function __construct($moduleName = '') {
		// Инициализация конфига
		Config::init($moduleName);

		// БД

		$this->db = DbClass::init([
			'host'    => DBHOST,
			'user'    => DBUSER,
			'pass'    => DBPASS,
			'db'      => DBNAME,
			'charset' => COLLATE,
		]);
	}

	/**
	 * @param array $params
	 */
	public function getTemplater($params = []) {
		$templatePath = (isset($params['templatePath'])) ? $params['templatePath'] : ROOT_DIR . '/templates/' . Config::get('dle.skin') . '/';
		$cachePath    = (isset($params['cachePath'])) ? $params['cachePath'] : ENGINE_DIR . '/cache/';

		unset($params['templatePath'], $params['cachePath']);

		$tplOptions = $params;

		$this->tpl = Fenom::factory(
			$templatePath,
			$cachePath,
			$tplOptions
		);

		// Добавляем модификаторы
		$this->addModifiers();

		// Тег постранички
		$this->tpl->addFunctionSmart('pages', 'bpModifiers::pages');

		// Банеры
		$this->tpl->addFunctionSmart('banner', 'bpModifiers::banner');

		/**
		 * Добавляем в шаблонизатор функцию, которая будет отмечать текущий пункт в меню
		 * Пример:
		 * <a href="?mod=components&action=componentslist" class="{selected request="action" value="componentslist"}">Компоненты</a>
		 */

		$this->tpl->addFunction('selected', function ($params) {

			if (isset($params['request']) && $_REQUEST[$params['request']] == $params['value']) {
				return 'selected';
			}

			return '';

		});

	}

	public function addModifiers() {
		$config = Config::get('dle');

		// Добавляем свой модификатор в шаблонизатор для корректного вывода аватарки юзера по его фотке
		$this->tpl->addModifier(
			'avatar', function ($foto) use ($config) {
			return bpModifiers::getAvatar($foto, $config['http_home_url']);
		}
		);

		// Добавляем свой модификатор в шаблонизатор для ограничения кол-ва символов в тексте
		$this->tpl->addModifier(
			'limit', function ($data, $limit, $etc = '&hellip;', $wordcut = false) use ($config) {
			return bpModifiers::textLimit($data, $limit, $etc, $wordcut, $config['charset']);
		}
		);

		// Добавляем свой модификатор в шаблонизатор для вывода print_r
		$this->tpl->addModifier(
			'dump', function ($data) {
			return bpModifiers::dump($data);
		}
		);

		// Добавляем свой модификатор в шаблонизатор для вывода картинок
		$this->tpl->addModifier(
			'declination', function ($n, $word) {
			return bpModifiers::declinationWords($n, $word);
		}
		);

		// Добавляем свой модификатор в шаблонизатор для вывода форматированной даты
		/*$this->tpl->addModifier(
			'dateformat', function ($data, $_f = false) {
				return formateDate($data, $_f);
			}
		);*/

		unset($config);
	}

	/**
	 * Метод для получения списка элементов
	 *
	 * Пример задания фильтра:
	 * $filter = [
	 *        'time_create'    => '>= || ADDDATE(NOW(), INTERVAL - 30 DAY)', // `create_time` >= 'ADDDATE(NOW(),
	 *        INTERVAL - 30 DAY)'
	 *        'views'          => '>=||1', // `views` > '1'
	 *    ];
	 *
	 * @param  string       $table      Имя таблицы, из которой будем отбирать данные
	 * @param  string       $fields     Поля, выбираемые из БД
	 * @param  array        $filter     Поля для фильтрации (поле => условие выборки)
	 * @param  integer      $pageNum    Номер страницы
	 * @param  integer      $perPage    Кол-во элементов, выводимых на страницу
	 * @param  string|array $order      Направление сортировки
	 * @param  string|array $orderField поле, по которому будем сортировать
	 * @param  array        $search     Поля для поиска и текст, который нужно искать: ['fields'=>['field1','field2'],
	 *                                  'text'=>'искомый текст']
	 *
	 * @return array Массив с результатами и количеством элеметнов в таблице
	 */
	public function getList(
		$table = 'dle_components',
		$fields = '*',
		$filter = [],
		$pageNum = 0,
		$perPage = 10,
		$order = 'ASC',
		$orderField = 'id',
		$search = []
	) {
		// Имя таблицы в БД

		// С какой записи начинаем
		$start = ($pageNum > 0) ? $perPage * $pageNum - $perPage : 0;
		// Обрабатываем фильтр отбора
		$where = $this->getFilteredWheres($filter);
		// Если был произведён поиск
		if (isset($search['text'])) {
			// Обрабатываем фразу
			$searchText     = $this->db->parse('?s', '%' . $search['text'] . '%');
			$arSearchInsert = [];
			// Подготавливаем поля для передачи в запрос
			foreach ($search['fields'] as $field) {
				$arSearchInsert[] = $this->db->parse('?n', $field) . ' LIKE ' . $searchText;
			}
			// В зависимости от наличия фильтра подставим нужный текст в запрос
			$isFilterCondition = (count($filter) > 0) ? ' AND ' : ' WHERE ';
			// Добавим условие запроса
			$where .= $isFilterCondition . implode(' OR ', $arSearchInsert);
		}
		// Если указана сортировка
		if ($orderField && !is_array($orderField)) {
			$where .= ' ORDER BY ' . $orderField . ' ' . $order;
		}
		// Если сортировка передана как массив
		if (is_array($orderField)) {
			$arOrderBy = [];

			foreach ($orderField as $key => $field) {
				$arOrderBy[] = $this->db->parse('?n', $field) . ' ' . (($order[$key] == 'ASC') ? 'ASC' : 'DESC');
			}

			if (count($arOrderBy)) {
				$where .= ' ORDER BY ' . implode(', ', $arOrderBy);
			}
		}
		// Формируем маску запроса
		$select = "SELECT ?p FROM ?n ?p LIMIT ?i, ?i";
		// Выполняем запрос на получение элементов
		$arList['items'] = $this->db->getAll($select, $fields, $table, $where, $start, $perPage);
		
		// Выполняем запрос на получения счётчика всех элементов
		$arList['count'] = $this->db->getOne('SELECT COUNT(*) as count FROM ?n ?p', $table, $where);


		// Возвращаем массив с данными
		return $arList;
	}

	/**
	 * Получаем список компонентов
	 *
	 * @param  integer $currentPage
	 * @param  integer $perPage
	 *
	 * @return array
	 */
	public function getComponentsList($currentPage = 0, $perPage = 10) {

		$compIds = $arList = [];

		$_arList = $this->getList(PREFIX . '_components', '*', [], $currentPage, $perPage, 'ASC', 'sort_index');

		foreach ($_arList['items'] as $key => $item) {
			$compIds[] = $item['id'];
			$arList['items'][$item['id']] = $item;
		}

		$arFields = $this->db->getAll('SELECT id, component_id, name, code FROM ?p WHERE component_id IN(?a)', PREFIX . '_components_fields_list', $compIds);

		foreach ($arFields as $key => $field) {
			$arList['items'][$field['component_id']]['fields_list'][] = $field;
		}

		unset($compIds, $arFields, $_arList);
		return $arList;

	}

	public function getComponentElements($componentName = '', $currentPage = 0, $perPage = 10) {
		return $arList = $this->getList(PREFIX . '_component_' . $componentName, '*', [], $currentPage, $perPage, 'ASC', 'sort_index');
	}

	/**
	 * Получаем список полей компонента
	 *
	 * @param  integer $componentId ID компонента.
	 *
	 * @return array                Поля компонента.
	 */
	public function getFieldsList($componentId = 0) {
		return $this->db->getAll(
			'SELECT f.*, t.description as field_type_description FROM ?n f LEFT JOIN ?n t ON (f.type=t.type) WHERE component_id=?i',
			PREFIX . '_components_fields_list',
			PREFIX . '_components_fields_types',
			$componentId
		);
	}

	public function getFieldsTypes() {
		return $this->db->getInd('type', 'SELECT * FROM ?n', PREFIX . '_components_fields_types');
	}

	/**
	 * Создание условий фильтрации в запросе
	 *
	 * @param  array $filter массив вида ключ => значение
	 *
	 * @return string         строка для подстановки в запрос
	 */
	public function getFilteredWheres($filter = []) {
		$wheres = [];
		$where  = '';
		if ($filter && count($filter)) {
			foreach ($filter as $key => $value) {
				$operator = '=';

				if (strpos($value, '||') !== false) {
					$arvalue  = explode('||', $value);
					$value    = $arvalue[1];
					$operator = $arvalue[0];
				}
				$value    = $this->db->parse('?s', $value);
				$wheres[] = $key . $operator . $value;
			}
			$where = ' WHERE ' . implode(' AND ', $wheres);

			return $where;
		}

		return $where;
	}

	/**
	 * Добавляем новую таблицу в БД
	 *
	 * @param string $name Название компонента
	 *
	 * @return FALSE|resource
	 */
	public function addComponentTable($name = '') {
		$queryText = "CREATE TABLE `" . PREFIX . "_component_" . $name . "` (
			`id` INT(11) NOT NULL AUTO_INCREMENT,
			`name` VARCHAR(255) NOT NULL,
			`alt_name` VARCHAR(255) NOT NULL,
			`sort_index` INT(6) NOT NULL DEFAULT '500',
			`image` VARCHAR(255) NOT NULL,
			`text` TEXT NOT NULL,
			`time_create` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
			`time_update` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
			PRIMARY KEY (`id`),
			INDEX `name` (`name`),
			INDEX `alt_name` (`alt_name`),
			INDEX `sort_index` (`sort_index`)
		);";

		try {
			return $this->db->query($queryText);
		} catch (Exception $e) {
			return $e->getMessage();
		}
	}

	public function redirect($page = '/', $messageType = 'info', $message = false) {
		if ($message) {
			$_SESSION['message']      = $message;
			$_SESSION['message_type'] = $messageType;
		}
		header('HTTP/1.0 301 Moved Permanently');
		header('Location: ' . $page);
		die('Redirect');
	}

	public function clearMessage() {
		unset($_SESSION['message'], $_SESSION['message_type']);
	}

	/**
	 * Фильтрация ненужных символов в кодах и менах полей,
	 * которые должны содержать только латиницу и цифры
	 *
	 * @param  string $string Строка, из которой нужно вырезать лишнее
	 *
	 * @return string         Очищенная строка
	 */
	public function leffersFilter($string = '') {
		$returnText = htmlspecialchars(strip_tags(trim($string)));

		return preg_replace("/([^a-z0-9_])/i", '', $returnText);
	}

	/**
	 * Фильтрация дефолтного значения допполя
	 *
	 * @param  mixed  $data Данные о дефолтном значении допполя
	 * @param  string $type Тип допполя
	 *
	 * @return string       Готовая строка для добавления в БД
	 */
	public function parseDefaulFieldValue($data = '', $type = '') {
		if ((!isset($data) || empty($data) || $data == '')) {
			return '';
		}

		if (is_array($data)) {
			$strReturn = $this->db->parse('?s', json_encode($data));
		} else {
			switch ($type) {
				case 'INT':
				case 'NID':
					$strReturn = $this->db->parse('?i', (int)$data);
					break;

				default:
					$strReturn = $this->db->parse('?s', $data);
					break;
			}
		}

		return $strReturn;
	}

} // Main