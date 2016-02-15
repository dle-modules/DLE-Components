{if $complete}
	<div class="cn-modal col-mb-8 col-7 col-dt-6">
		<div class="cn-modal-content clearfix">
			<div class="alert alert-success">
				Дополнительное поле <b>{$arField.name}</b> создано!
			</div>
			<div class="col-margin-top ta-center">
				<span class="btn btn-location-reload">Закрыть окно</span>
			</div>
		</div>
	</div>
{else}
	<form class="col-margin" action="{$config.http_home_url}engine/ajax/components/editfield.php" method="post" data-ajax-submit>
		<div class="cn-modal  col-mb-12 {if !$arField.type}col-6 col-dt-5{else}col-11 col-dt-10 col-ld-7{/if} ">
			<div class="mfp-close cn-modal-close">&times;</div>
			<div class="cn-modal-header">
				Новое допполе
			</div>

			
			<div class="cn-modal-content clearfix">
				{if !$arField.type}	
					<div class="content">
						<div class="col col-mb-12 col-margin-bottom">
							<div class="h4 mb0 text-primary">
								Тип поля						
							</div>
							<div class="text-light">
								<small>От типа поля зависит то, как будут храниться данные этого поля</small>
							</div>
							<select name="type" class="styler input-block selectSubmitOnChange" data-placeholder="Выберите тип поля">
								<option value=""></option>
								{foreach $fieldsTypes as $field}
									<option value="{$field.type}">{$field.description}</option>
								{/foreach}
							</select>
						</div>
					</div>				
				{else}
					{if $fieldsTypes[$arField.type]}
						<div class="content">
							<div class="col col-mb-12">
								<div class="alert alert-info">
									Выбранный тип поля: "{$fieldsTypes[$arField.type]['description']}"
								</div>						
							</div>	
						</div>
					{/if}
					{if $error}
						<div class="content">
							<div class="col col-mb-12">
								<div class="alert alert-error col-margin-top">
									<ul class="m0">
										{foreach $errors as $err}
											<li>{$err}</li>
										{/foreach}
									</ul>
								</div>
							</div>
						</div>
					{/if}
					<div class="content">
						<div class="col col-mb-12 col-6">
							<div class="equal">
								<div class="h4 mb0 text-primary">
									Код						
								</div>
								<div class="text-light">
									<small>Код поля должен содержать только латинские буквы и цифры</small>
								</div>
							</div>
							<input class="input input-block input-mask-latin" type="text" name="code" value="{$arField.code}" required>
						</div>
						<div class="col col-mb-12 col-6">
							<div class="equal">
								<div class="h4 mb0 text-primary">
									Название						
								</div>
								<div class="text-light">
									<small>Название поля для удобства восприятия в списке полей</small>
								</div>
							</div>
							<input class="input input-block" type="text" name="name" value="{$arField.name}" required>
						</div>
					</div>
					<div class="content">
						<div class="col col-mb-12">
							<div class="h4 mb0 text-primary">
								Описание						
							</div>
							<div class="text-light">
								<small>Кратко опишите назначение создаваемого поля</small>
							</div>
							<textarea class="input input-block" name="description">{$arField.description}</textarea>
						</div>
					</div>
					<div class="content">
						<div class="col col-mb-12">
							<div class="h4 mb0 text-primary">
								Значение по умолчанию						
							</div>
							<div class="text-light">
								<small>Это значение будет подставлено автоматически в форме добавления элемента.</small>
							</div>
							{include '/actions/fieldvalue.tpl' field=$arField}
						</div>
					</div>
			
					<div class="content">
						<div class="col col-mb-12">
							<div class="h4 mb0 text-primary">
								Признаки					
							</div>
							<div>
								<input class="checkbox" type="checkbox" id="ckbx_d_r" name="is_required" {if $arField.is_required}checked{/if}>
								<label for="ckbx_d_r"><span></span> Обязательное</label>
							</div>
							<div>
								<input class="checkbox" type="checkbox" id="ckbx_d_m" name="is_multiple" {if $arField.is_multiple}checked{/if}>
								<label for="ckbx_d_m"><span></span> Множественное</label>
							</div>
						</div>
					</div>
			
			
					<div class="content col-margin-top">
						<div class="col col-mb-12">
							<button class="btn btn-big ladda-button mr10" type="submit" data-style="zoom-in"><span class="ladda-label">Добавить</span></button>
							<span class="btn btn-big btn-link modal-dismiss">Отменить</span>
						</div>
					</div>
					
					<input type="hidden" name="type" value="{$arField.type}">
					<input type="hidden" name="complete" value="y">
				{/if}
			</div> <!-- .cn-modal-content clearfix --> <!-- .cn-modal -->

			<input type="hidden" name="componentid" value="{$component.id}">
			<input type="hidden" name="action" value="add">
		</div>
	</form>
{/if}