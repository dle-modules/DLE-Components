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

if (!defined('DATALIFEENGINE') OR !defined('LOGGED_IN')) {
	die('Hacking attempt!');
}
if ($member_id['user_group'] != '1') {
	msg('error', $lang['index_denied'], $lang['index_denied']);
}

include_once ENGINE_DIR . '/modules/components/admin/index.php';