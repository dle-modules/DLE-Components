{$arField|d}

{switch $arField.type}
	{case 'TXT'}
	{case 'NUM'}
		<input class="input input-block" type="text" name="default_value" value="{$arField.default_value}">
	
	{case 'TXTM'}
		<textarea class="input input-block" name="default_value">{$arField.default_value}</textarea>

	{case 'INT'}
		<input class="input input-block" type="number" name="default_value" value="{$arField.default_value}">
	
	{case 'FILE'}
		<input class="input input-block" type="file" name="default_value">

	{case default}
		{* code *}
{/switch}