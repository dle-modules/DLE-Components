-- --------------------------------------------------------
-- Хост:                         components.loc
-- Версия сервера:               5.5.45 - MySQL Community Server (GPL)
-- ОС Сервера:                   Win32
-- HeidiSQL Версия:              9.3.0.4984
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Дамп структуры для таблица components.dle_components
CREATE TABLE IF NOT EXISTS `dle_components` (
  `id` int(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `fields` text NOT NULL,
  `read_access` varchar(200) NOT NULL,
  `write_access` varchar(200) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sort_index` (`sort_index`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='Таблица для хранения компонентов';

-- Дамп данных таблицы components.dle_components: ~6 rows (приблизительно)
/*!40000 ALTER TABLE `dle_components` DISABLE KEYS */;
INSERT INTO `dle_components` (`id`, `name`, `sort_index`, `fields`, `read_access`, `write_access`, `description`) VALUES
	(1, 'news', 400, '', '3,4', '2,3', 'Описание для первого компонента 12'),
	(3, 'newsNew', 154, '', '3', '', ''),
	(4, 'news2', 300, '', '', '', 'Описание компонента новостей №2'),
	(5, 'news3', 500, '', '3', '4', 'Описание для компонента новостей 3'),
	(6, 'fooo', 500, '', '', '', '');
/*!40000 ALTER TABLE `dle_components` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_components_fields_data
CREATE TABLE IF NOT EXISTS `dle_components_fields_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL,
  `element_id` int(11) NOT NULL,
  `field_list_id` int(11) NOT NULL,
  `type` char(4) NOT NULL DEFAULT 'TXT',
  `value` text,
  `value_int` int(11) DEFAULT '0',
  `value_num` decimal(18,4) DEFAULT '0.0000',
  PRIMARY KEY (`id`),
  KEY `component_id` (`component_id`),
  KEY `element_id` (`element_id`),
  KEY `field_list_id` (`field_list_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='Данные дополнительных полей компонентов';

-- Дамп данных таблицы components.dle_components_fields_data: ~2 rows (приблизительно)
/*!40000 ALTER TABLE `dle_components_fields_data` DISABLE KEYS */;
INSERT INTO `dle_components_fields_data` (`id`, `component_id`, `element_id`, `field_list_id`, `type`, `value`, `value_int`, `value_num`) VALUES
	(1, 3, 1, 16, 'TXT', 'Тестовое описание поля', NULL, NULL),
	(2, 3, 1, 17, 'TXTM', 'Тестовое описание другого поля', NULL, NULL);
/*!40000 ALTER TABLE `dle_components_fields_data` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_components_fields_list
CREATE TABLE IF NOT EXISTS `dle_components_fields_list` (
  `id` tinyint(3) NOT NULL AUTO_INCREMENT,
  `component_id` int(11) NOT NULL,
  `type` char(4) NOT NULL DEFAULT 'TXT',
  `name` varchar(50) NOT NULL,
  `code` varchar(50) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `description` varchar(255) NOT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '0',
  `is_multiple` tinyint(1) NOT NULL DEFAULT '0',
  `default_value` text,
  PRIMARY KEY (`id`),
  KEY `component_id` (`component_id`),
  KEY `type` (`type`),
  KEY `sort_index` (`sort_index`),
  KEY `is_required` (`is_required`),
  KEY `is_multiple` (`is_multiple`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='Таблица для хранения списка допполей компонентов';

-- Дамп данных таблицы components.dle_components_fields_list: ~13 rows (приблизительно)
/*!40000 ALTER TABLE `dle_components_fields_list` DISABLE KEYS */;
INSERT INTO `dle_components_fields_list` (`id`, `component_id`, `type`, `name`, `code`, `sort_index`, `description`, `is_required`, `is_multiple`, `default_value`) VALUES
	(15, 1, 'RAD', 'Название радиокнопки', 'field1', 500, '', 1, 1, '{"0":{"value":"123","label":"\\u043f\\u0440\\u0438\\u0432\\u0435\\u0442"},"3":{"value":"1234","label":"\\u043f\\u043e\\u043a\\u0430"}}'),
	(16, 3, 'TXT', 'Поле 333', 'field1', 200, 'В это поле вводим какую-нибудь простую текстовую информацию', 0, 1, 'привет'),
	(17, 3, 'TXTM', 'Поле 2', 'field2', 100, 'Краткое описание многострочного допполя', 1, 0, ''),
	(18, 3, 'INT', 'Числовое поле', 'field3', 200, 'В это поле можно вводить только цифры', 0, 0, '0'),
	(19, 3, 'NUM', 'Цена ', 'field4', 500, 'В это поле вбиваем цену элемента', 0, 1, ''),
	(20, 3, 'FILE', 'field5', 'field5', 500, 'field5', 0, 0, NULL),
	(21, 3, 'LIST', 'field6', 'field6', 500, 'field6', 0, 0, '[{"value":"field6_1","label":"\\u041f\\u0440\\u0438\\u0432\\u0435\\u0442 1"},{"value":"field6_2","label":"\\u041f\\u0440\\u0438\\u0432\\u0435\\u0442 2"},{"value":"field6_3","label":""},{"value":"field6_4","label":"12345"},{"value":"123","label":"\\u041e\\u0447\\u0435\\u043d\\u044c \\u0434\\u043b\\u0438\\u043d\\u043d\\u043e\\u0435 \\u043d\\u0430\\u0437\\u0432\\u0430\\u043d\\u0438\\u0435 \\u043f\\u043e\\u043b\\u044f \\u0434\\u043b\\u044f \\u043f\\u0440\\u043e\\u0432\\u0435\\u0440\\u043a\\u0438 \\u0435\\u0433\\u043e \\u043e\\u0442\\u043e\\u0431\\u0440\\u0430\\u0436\\u0435\\u043d\\u0438\\u044f \\u0432 \\u0444\\u043e\\u0440\\u043c\\u0435 \\u0440\\u0435\\u0434\\u0430\\u043a\\u0442\\u0438\\u0440\\u043e\\u0432\\u0430\\u043d\\u0438\\u044f"},{"value":"456","label":""},{"value":"789","label":""},{"value":"101112","label":""},{"value":"131415","label":""},{"value":"161718","label":""}]'),
	(22, 3, 'CHK', 'field7', 'field7', 500, 'field7', 0, 0, '[{"value":"field7_1","label":"\\u041f\\u0440\\u0438\\u0432\\u0435\\u0442 1"},{"value":"field7_2","label":""},{"value":"field7_3","label":"\\u041f\\u0420\\u0438\\u0432\\u0435\\u04422"}]'),
	(24, 3, 'RAD', 'field8', 'field8', 500, 'field8', 0, 0, '[{"value":"field8_1","label":"field8_1"},{"value":"field8_2","label":"field8_2"}]'),
	(25, 3, 'DATE', 'Дата события', 'field9', 500, 'Сюда вписываем дату события в формате дд.мм.гггг', 1, 1, '2015-03-08'),
	(26, 3, 'NID', 'Приязка к новости', 'field10', 500, 'В поле нужно вбить ID новости (со временем это заменем на нормальный интерфейс)', 1, 1, '4'),
	(27, 3, 'CID', 'ID Элемента', 'field11', 500, 'Привязка к элементу компонента. Нужно указать ID компонента и ID элемента ', 1, 1, '{"component":"155","element":""}'),
	(28, 3, 'IMG', 'field12', 'field12', 500, 'field12', 0, 0, NULL);
/*!40000 ALTER TABLE `dle_components_fields_list` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_components_fields_types
CREATE TABLE IF NOT EXISTS `dle_components_fields_types` (
  `id` tinyint(3) NOT NULL AUTO_INCREMENT,
  `type` char(4) NOT NULL,
  `description` varchar(255) NOT NULL,
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT COMMENT='Таблица для хранения типов допполей';

-- Дамп данных таблицы components.dle_components_fields_types: ~12 rows (приблизительно)
/*!40000 ALTER TABLE `dle_components_fields_types` DISABLE KEYS */;
INSERT INTO `dle_components_fields_types` (`id`, `type`, `description`) VALUES
	(1, 'TXT', 'Простое текстовое поле'),
	(2, 'TXTM', 'Многострочное тестовое поле'),
	(3, 'INT', 'Число'),
	(4, 'NUM', 'Цена'),
	(5, 'FILE', 'Файл'),
	(6, 'LIST', 'Список'),
	(7, 'CHK', 'Чекбокс'),
	(8, 'RAD', 'Радиокнопка'),
	(9, 'DATE', 'Дата'),
	(10, 'NID', 'Привязка к новости'),
	(11, 'CID', 'Привязка к элементу компонента'),
	(12, 'IMG', 'Картинка');
/*!40000 ALTER TABLE `dle_components_fields_types` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_component_fooo
CREATE TABLE IF NOT EXISTS `dle_component_fooo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `alt_name` varchar(255) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `image` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `time_create` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_update` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `alt_name` (`alt_name`),
  KEY `sort_index` (`sort_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы components.dle_component_fooo: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `dle_component_fooo` DISABLE KEYS */;
/*!40000 ALTER TABLE `dle_component_fooo` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_component_news
CREATE TABLE IF NOT EXISTS `dle_component_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `alt_name` varchar(255) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `image` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `time_create` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_update` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `alt_name` (`alt_name`),
  KEY `sort_index` (`sort_index`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы components.dle_component_news: ~2 rows (приблизительно)
/*!40000 ALTER TABLE `dle_component_news` DISABLE KEYS */;
INSERT INTO `dle_component_news` (`id`, `name`, `alt_name`, `sort_index`, `image`, `text`, `time_create`, `time_update`) VALUES
	(1, 'Новость 1', 'news-1', 500, '', 'Какойто текст новости тут описан.', '2016-01-30 12:21:00', '2016-01-30 12:21:00'),
	(2, 'Новость 2', 'news2', 500, '', 'Описание новости 2', '2016-01-30 22:38:00', '2016-01-30 22:38:00');
/*!40000 ALTER TABLE `dle_component_news` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_component_news2
CREATE TABLE IF NOT EXISTS `dle_component_news2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `alt_name` varchar(255) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `image` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `time_create` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_update` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `alt_name` (`alt_name`),
  KEY `sort_index` (`sort_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы components.dle_component_news2: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `dle_component_news2` DISABLE KEYS */;
/*!40000 ALTER TABLE `dle_component_news2` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_component_news3
CREATE TABLE IF NOT EXISTS `dle_component_news3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `alt_name` varchar(255) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `image` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `time_create` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_update` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `alt_name` (`alt_name`),
  KEY `sort_index` (`sort_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Дамп данных таблицы components.dle_component_news3: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `dle_component_news3` DISABLE KEYS */;
/*!40000 ALTER TABLE `dle_component_news3` ENABLE KEYS */;


-- Дамп структуры для таблица components.dle_component_newsNew
CREATE TABLE IF NOT EXISTS `dle_component_newsNew` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `alt_name` varchar(255) NOT NULL,
  `sort_index` int(6) NOT NULL DEFAULT '500',
  `image` varchar(255) NOT NULL,
  `text` text NOT NULL,
  `time_create` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_update` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `name` (`name`),
  KEY `alt_name` (`alt_name`),
  KEY `sort_index` (`sort_index`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Дамп данных таблицы components.dle_component_newsNew: ~1 rows (приблизительно)
/*!40000 ALTER TABLE `dle_component_newsNew` DISABLE KEYS */;
INSERT INTO `dle_component_newsNew` (`id`, `name`, `alt_name`, `sort_index`, `image`, `text`, `time_create`, `time_update`) VALUES
	(1, 'Новость 1', 'news1', 500, '', 'Текст первой новости', '2016-02-04 12:00:00', '2016-02-04 12:00:00');
/*!40000 ALTER TABLE `dle_component_newsNew` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
