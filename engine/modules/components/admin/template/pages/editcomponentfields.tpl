{extends 'app.tpl'}

{block 'content'}
	<div class="content">
		<div class="col col-mb-12 col-6">
			<div class="h3 m0">{$component.name} — Допполя</div>
		</div>
		<div class="col col-mb-12 col-6 ta-right">
			<span
				data-mfp-src="{$config.http_home_url}engine/ajax/components/editfield.php"				
				data-settings='{ "action": "add", "componentid": "{$component.id}"  }' 
				class="btn btn-small btn-primry btn-outline btn-field-edit"
			><i class="icon-plus"></i> Добавить допполе</span>
		</div>
	</div>

	<div class="content  col-margin">
		{foreach $fieldsList as $key => $arField index=$index}
			{if $index > 0}
				<div class="col col-mb-12">
					<hr class="gray">
				</div>
			{/if}
			<div class="col col-mb-6 col-4 col-dt-3 equal">
				{$arField.code} <br>
				<small class="text-muted">{$arField.field_type_description}</small>
			</div>
			<div class="col col-mb-6 col-4 col-dt-5 equal">
				<b>{$arField.name}</b> <br> {$arField.description}
			</div>
			<div class="col col-mb-10 col-3 col-dt-3 equal fz14">
				<div>
					<input class="checkbox" type="checkbox" id="ckbx_d_r" disabled {if $arField.is_required}checked{/if}>
					<label for="ckbx_d_r"><span></span> Обязательное</label>
				</div>
				<div>
					<input class="checkbox" type="checkbox" id="ckbx_d_m" disabled {if $arField.is_multiple}checked{/if}>
					<label for="ckbx_d_m"><span></span> Множественное</label>
				</div>
			</div>
			<div class="col col-mb-2 col-1 col-dt-1 equal ta-right">
				<span 
					class="btn btn-small btn-outline mt10 btn-field-edit"
					data-mfp-src="{$config.http_home_url}engine/ajax/components/editfield.php"
					data-settings='{ "action": "edit", "componentid": "{$component.id}", "id": "{$arField.id}" }'
				><i class="icon icon-cog"></i></span>
			</div>	
		{/foreach}
	</div> <!-- .content -->

{/block}

