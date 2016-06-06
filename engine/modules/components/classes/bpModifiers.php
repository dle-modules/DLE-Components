<?php

/*
=============================================================================
BASE - базовый класс для модулей
=============================================================================
Автор:   ПафНутиЙ
URL:     http://pafnuty.name/
twitter: https://twitter.com/pafnuty_name
google+: http://gplus.to/pafnuty
email:   pafnuty10@gmail.com
=============================================================================
 */

class bpModifiers extends Main {

	/**
	 * @param        $data    - контент
	 * @param        $limit
	 * @param string $etc     - Окончание обрезанного текста
	 * @param bool   $wordcut - жесткое ограничение символов
	 *
	 * @param string $charset
	 *
	 * @return string $data - обрезанный результат
	 */
	public static function textLimit($data, $limit, $etc = '&hellip;', $wordcut = false, $charset = 'utf-8') {
		$data = strip_tags($data, '<br>');
		$data = trim(str_replace(['<br>', '<br />'], ' ', $data));

		if ($limit && dle_strlen($data, $charset) > $limit) {
			$data = dle_substr($data, 0, $limit, $charset) . $etc;
			if (!$wordcut && ($word_pos = dle_strrpos($data, ' ', $charset))) {
				$data = dle_substr($data, 0, $word_pos, $charset) . $etc;
			}

		}

		return $data;
	}

	/**
	 * Функция для правильного склонения слов
	 *
	 * @param int    $n     - число, для которого будет расчитано окончание
	 * @param string $words - варианты окончаний для (1 комментарий, 2 комментария, 100 комментариев)
	 *
	 * @return string - слово с правильным окончанием
	 */
	public static function declinationWords($n = 0, $words) {
		$words = explode('|', $words);
		$n     = abs((int)$n); // abs на случай отрицательного значения
		return $n % 10 == 1 && $n % 100 != 11
			? $words[0] . $words[1]
			: ($n % 10 >= 2 && $n % 10 <= 4 && ($n % 100 < 10 || $n % 100 >= 20) ? $words[0] . $words[2]
				: $words[0] . $words[3]);

	}

	/**
	 * Функция для вывода print_r в шаблон
	 *
	 * @param  mixed $var входящие данные]
	 *
	 * @return string    print_r
	 */
	public static function dump($var) {
		return print_r($var, true);
	}

	/**
	 * Тег постраничной навигации
	 *
	 * @param  array $config конфиг
	 * @param  int   $total  Общее кол-во страниц
	 *
	 * @return string        формированный блок с постраничкой
	 */
	public static function pages($config, $total) {

		$config['total_items'] = $total;
		$pages                 = '';

		if ($total > $config['items_per_page']) {
			$pagination = new Pager($config);

			// Сформированный блок с постраничкой
			$pages = $pagination->render();
		}

		return $pages;
	}

	/**
	 * Получаем аватар пользователя
	 *
	 * @param  string $foto          фото пользователя
	 *
	 * @param string  $http_home_url домен
	 *
	 * @return string /bool      src или false
	 */
	public static function getAvatar($foto, $http_home_url = '/') {
		if (count(explode("@", $foto)) == 2) {
			$avatar = '//www.gravatar.com/avatar/' . md5(trim($foto)) . '?s=50';
		} else {
			if ($foto) {
				if (strpos($foto, "//") === 0) {
					$_avatar = "http:" . $foto;
				} else {
					$_avatar = $foto;
				}

				$_avatar = @parse_url($_avatar);

				if ($_avatar['host']) {

					$avatar = $foto;

				} else {
					$avatar = $http_home_url . 'uploads/fotos/' . $foto;
				}

			} else {
				$avatar = '';
			}
		}

		return $avatar;
	}

	public static function banner($name = '') {
		$db = DbClass::init();
		global $member_id;

		$banner = $db->getRow('SELECT * FROM ?n WHERE banner_tag = ?s AND approve', PREFIX . '_banners', $name);

		if ($banner['id']) {
			if ($banner['grouplevel'] != 'all') {
				$arGroups = explode(',', $banner['grouplevel']);
				if (in_array($member_id['user_group'], $arGroups)) {
					return $banner['code'];
				} else {
					return false;
				}
			}

			return $banner['code'];

		}

		return false;
	}

} // bpModifiers
