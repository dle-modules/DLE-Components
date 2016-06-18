{if $complete}
	<div class="cn-modal col-mb-8 col-7 col-dt-6">
		<div class="cn-modal-content clearfix">
			<div class="alert alert-success">
				Дополнительное поле <b>{$arField.name}</b> изменено!
			</div>
			<div class="col-margin-top ta-center">
				<span class="btn btn-location-reload">Закрыть окно</span>
			</div>
		</div>
	</div>
{else}
	<form action="{$config.http_home_url}engine/ajax/components/editfield.php" method="post" data-ajax-submit>
		<div class="cn-modal col-margin col-mb-12 col-11 col-dt-10 col-ld-7">
			<div class="mfp-close cn-modal-close">&times;</div>
			<div class="cn-modal-header">
				Редактирование дополнительного поля "{$arField.name}"
			</div>
			
			<div class="cn-modal-content clearfix">
			
				<div class="content">
					<div class="col col-mb-12">
						<div class="alert alert-info">
							<p>Тип поля: "{$fieldsTypes[$arField.type]['description']}"</p>
							<p>Код поля: "{$arField.code}"</p>
						</div>						
					</div>	
				</div>
			
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
					<div class="col col-mb-12 col-8">
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
					<div class="col col-mb-12 col-4">
						<div class="h4 mb0 text-primary">Индекс сортировки</div>
						<div class="text-light"><small>Чем меньше число - тем выше поле в списке</small></div>
						<input class="input input-block" type="number" name="sort_index" value="{$arField.sort_index}">
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
						{if $arField.type not in list ['CHK', 'RAD']}
							<div>
								<input class="checkbox" type="checkbox" id="ckbx_d_m" name="is_multiple" {if $arField.is_multiple}checked{/if}>
								<label for="ckbx_d_m"><span></span> Множественное</label>
							</div>
						{/if}
					</div>
				</div>
			
			
				<div class="content col-margin-top col-all-middle">
					<div class="col col-mb-12 col-8">
						<button class="btn btn-big ladda-button mr10" type="submit" data-style="zoom-in"><span class="ladda-label">Сохранить</span></button>
						<span class="btn btn-big btn-link modal-dismiss">Отменить</span>
					</div>
					<div class="col col-mb-12 col-4 ta-right">
						<span class="btn btn-secondary btn-outline btn-delete-field">Удалить допполе</span>
					</div>
				</div> 	
			</div> <!-- .cn-modal-content clearfix --> <!-- .cn-modal -->
		</div>

		<input type="hidden" name="complete" value="y">
		<input type="hidden" name="action" value="edit">
		<input type="hidden" name="componentid" value="{$component.id}">
		<input type="hidden" name="id" value="{$arField.id}">
	</form>
{/if}