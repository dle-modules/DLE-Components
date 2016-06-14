[![Stories in Ready](https://badge.waffle.io/dle-modules/DLE-Components.png?label=ready&title=Ready)](https://waffle.io/dle-modules/DLE-Components)
# DLE-Components
Модуль компонентов для DLE

# Модуль в стадии  начальной разработки

```sql
CREATE TABLE `dle_components` (
    `id` INT(6) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `sort_index` INT(6) NOT NULL DEFAULT '500',
    `fields` TEXT NOT NULL,
    `read_access` VARCHAR(200) NOT NULL,
    `write_access` VARCHAR(200) NOT NULL,
    `description` TEXT NOT NULL,
    PRIMARY KEY (`id`),
    INDEX `sort_index` (`sort_index`)
)
COMMENT='Таблица для хранения компонентов'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `dle_components_fields_list` (
    `id` TINYINT(3) NOT NULL AUTO_INCREMENT,
    `component_id` INT(11) NOT NULL,
    `type` CHAR(4) NOT NULL DEFAULT 'TXT',
    `name` VARCHAR(50) NOT NULL,
    `code` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `is_required` TINYINT(1) NOT NULL DEFAULT '0',
    `is_multiple` TINYINT(1) NOT NULL DEFAULT '0',
    `default_value` TEXT NULL,
    PRIMARY KEY (`id`),
    INDEX `component_id` (`component_id`),
    INDEX `type` (`type`)
)
COMMENT='Таблица для хранения списка допполей компонентов'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `dle_components_fields_types` (
    `id` TINYINT(3) NOT NULL AUTO_INCREMENT,
    `type` CHAR(4) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    UNIQUE INDEX `id` (`id`),
    UNIQUE INDEX `type` (`type`)
)
COMMENT='Таблица для хранения типов допполей'
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

INSERT INTO `dle_admin_sections` (`name`, `title`, `descr`, `icon`, `allow_groups`) VALUES
    ('components', 'DLE-Components', 'Компоненты для DLE', 'components.png', '1');
```


