<form action="{$config.http_home_url}engine/ajax/components/editfield.php" method="post" enctype="multipart/form-data" data-ajax-submit>
	<div class="cn-modal col-mb-12 col-9 col-dt-7">
		<div class="mfp-close cn-modal-close">&times;</div>
		<div class="cn-modal-header">
			Редактирование дополнительного поля "{$arField.name}"
		</div>
		<div class="cn-modal-content clearfix">
			<div class="content col-margin">
				<div class="col col-mb-12 col-3 col-dt-4">
					Код
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					{$arField.code}
				</div>
			</div>
			<div class="content col-margin">
				<div class="col col-mb-12 col-3 col-dt-4">
					Тип
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					{$arField.field_type_description}
				</div>
			</div>

			<div class="content col-margin">
				<div class="col col-mb-12 col-3 col-dt-4 mt8">
					Название
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					<input class="input input-block" type="text" name="name" value="{$arField.name}">
				</div>
			</div>

			<div class="content col-margin">
				<div class="col col-mb-12 col-3 col-dt-4 mt8">
					Описание
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					<textarea class="input input-block" name="description">{$arField.description}</textarea>
				</div>
			</div>

			<div class="content col-margin">
				<div class="col col-mb-12 col-3 col-dt-4 mt8">
					Значение по умолчанию
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					{include '/actions/fieldvalue.tpl' field=$arField}
				</div>
			</div>

			<div class="content col-margin">

				<div class="col col-mb-hide col-3 col-dt-4">
					&nbsp;
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					<div>
						<input class="checkbox" type="checkbox" id="ckbx_d_r" {if $arField.is_required}checked{/if}>
						<label for="ckbx_d_r"><span></span> Обязательное</label>
					</div>
					<div>
						<input class="checkbox" type="checkbox" id="ckbx_d_m" {if $arField.is_multiple}checked{/if}>
						<label for="ckbx_d_m"><span></span> Множественное</label>
					</div>
				</div>
			</div>
			<div class="content col-margin-top">
				<div class="col col-mb-hide col-3 col-dt-4">
					&nbsp;
				</div>
				<div class="col col-mb-12 col-9 col-dt-8">
					<button class="btn ladda-button" type="submit" data-style="zoom-in"><span class="ladda-label">Сохранить</span></button>
				</div>
			</div>
		</div> <!-- .cn-modal-content clearfix -->
	</div> <!-- .cn-modal -->


	<input type="hidden" name="id" value="{$arField.id}">
	<input type="hidden" name="action" value="edit">
	<input type="hidden" name="done" value="y">
</form>

{* {$arField|s} *}

{*     'id' => string (1) "1"
    'component_id' => string (1) "3"
    'type' => string (3) "TXT"
    'name' => string UTF-8 (4) "Тема"
    'code' => string (5) "theme"
    'description' => string UTF-8 (18) "Описание поля Тема"
    'is_required' => string (1) "0"
    'is_multiple' => string (1) "0"
    'default_value' => NULL
    'field_type_description' => string UTF-8 (22) "Простое текстовое поле" *}