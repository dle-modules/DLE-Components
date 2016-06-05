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
 * Класс-обёртка для работы с БД
 */
class Builder {

	public $db;

	function __construct() {
		$this->db = DbClass::init([
			'host'    => DBHOST,
			'user'    => DBUSER,
			'pass'    => DBPASS,
			'db'      => DBNAME,
			'charset' => COLLATE,
		]);
	}

	/**
	 * Метод для получения списка элементов
	 *
	 * @param  string       $table      Имя таблицы, из которой будем отбирать данные
	 * @param  string       $fields     Поля, выбираемые из БД
	 * @param  array        $filter     Поля для фильтрации (поле => условие выборки)
	 * @param  integer      $pageNum    Номер страницы
	 * @param  integer      $perPage    Кол-во элементов, выводимых на страницу
	 * @param  string|array $order      Направление сортировки
	 * @param  string|array $orderField поле, по которому будем сортировать
	 * @param  array        $search     Поля для поиска и текст, который нужно искать: array('fields'=>array('field1','field2'), 'text'=>'искомый текст')
	 *
	 * @return array Массив с результатами и количеством элеметнов в таблице
	 */
	/*public function getList(
		$table = 'dle_components',
		$fields = '*',
		$filter = [],
		$pageNum = 0,
		$perPage = 10,
		$order = 'ASC',
		$orderField = 'create_time',
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
	}*/

}