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
class DbClass extends SafeMySQL {

	public static function init($options = []) {
		static $db;

		if (!is_object($db)) {
			$db = new DbClass($options);
		}
		return $db;
	}
}