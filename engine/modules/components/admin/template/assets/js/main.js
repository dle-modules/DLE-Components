
var laddaLoad;

$(document)
// Псевдо-ссылки 2.0
// для открытия "ссылки" в текущем окне
	.on('click', '[data-target-self]', function (e) {
		var url = $(this).data('targetSelf');
		if (e.metaKey || e.ctrlKey || e.button === 1) {
			window.open(url);
		}
		else {
			location = url;
		}
	})
	// для открытия "ссылки" в новом окне
	.on('click', '[data-target-blank]', function () {
		window.open($(this).data('targetBlank'));
	})
	.on('click touchend', '[data-click-target]', function (e) {
		// Эмулируем клик по другому элементу
		e.preventDefault();
		var $target = $($(this).data('clickTarget'));
		if (e.type == 'touchend') {
			doc.off('click', $target);
		}
		$target.trigger('click');
	})
	// Меню редактирования
	.on('click', '.editmenu-btn', function (event) {
		event.preventDefault();
		var $this = $(this),
			$parent = $this.closest('.editmenu');

		if ($parent.hasClass('opened')) {
			$parent.removeClass('opened');
		}
		else {
			$('.editmenu').removeClass('opened');
			$parent.addClass('opened');
		}
	})
	// Закрываем меню редактирования при клике мимо него
	.on('click', 'body', function (e) {
		if ($(e.target).closest('.editmenu-ul').length || $(e.target).closest('.editmenu-btn').length) {
			return;
		}
		$('.editmenu').removeClass('opened');
	})
	.on('click', '.btn-field-edit', function (e) {
		e.preventDefault();
		var $data = $(this).data();

		$.magnificPopup.open({
			items: {
				src: $data.mfpSrc
			},
			focus: 'input[type="text"]',
			type: 'ajax',
			ajax: {
				settings: {
					data: $data.settings
				},
				cursor: 'mfp-ajax-cur'
			},
			callbacks: {
				ajaxContentAdded: function () {
					selectStyler($(this.content).find('.styler'));
					$(this.content).find('.equal').matchHeight();
					setPriceMask();
				}
			}
		});

	})
	.on('click', '.modal-dismiss', function (event) {
		event.preventDefault();
		$.magnificPopup.close();
	})
	// Аякс отправка формы с эффектами
	.on('submit', '[data-ajax-submit]', function () {
		var $this = $(this),
			options = {
				beforeSubmit: processStart,
				success: processDone
			};

		$this.ajaxSubmit(options);

		return false;
	})
	.on('change', '.selectSubmitOnChange', function (e) {
		e.preventDefault();
		$(this).closest('form').submit();
	})
	.on('click', '[data-add-list-field]', function (e) {
		e.preventDefault();
		var $this = $(this),
			key = $this.data('addListField'),
			$field = $('<div class="content"><div class="col col-mb-12 col-4 col-dt-4"><input class="input input-block input-mask-latin" type="text" name="default_value[' + key + '][value]" placeholder="Значение" required></div><div class="col col-mb-12 col-5 col-dt-6"><input class="input input-block" type="text" name="default_value[' + key + '][label]" placeholder="Отображаемый текст"></div><div class="col col-mb-12 col-3 col-dt-2"><span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" data-remove-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span></div><div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div></div>');

		if ($this.data('addListTemplate')) {
			var template = $('#' + $this.data('addListTemplate')).html();
			$field = $((simpleJsTemplater(template, {key: key})));
			$field.insertBefore($this).find('.focusme').focus();
			setPriceMask();
		} else {
			$field.insertBefore($this).find('[name="default_value[' + key + '][value]"]').focus();
		}

		$this.data('addListField', key + 1);
	})
	.on('click', '[data-remove-list-field]', function (e) {
		e.preventDefault();
		$(this).closest('.content').remove();
	})
	.on('input', '.input-mask-latin', function () {
		var start = this.selectionStart,
			end = this.selectionEnd,
			oldValueLength = this.value.length;

		this.value = this.value.replace(/[^a-zA-Z0-9]/g, '');

		var delta = oldValueLength - this.value.length;
		start = start - delta;
		end = end - delta;

		this.setSelectionRange(start, end);
	})
	.on('click', '.btn-location-reload', function(event) {
		event.preventDefault();
		location.reload();
	})
	.on('click', '.btn-delete-field', function() {
		var $this = $(this),
			$form = $this.closest('[data-ajax-submit]');

		var confirmDelete = confirm('Вы действительно хотите удалить это допполе? Действие нельзя будет отменить!');
		if (confirmDelete) {
			$form.find('[name="action"]').val('delete').end().trigger('submit');
		}
	})
	.on('submit', 'form', function(event) {
		$.each($('.input-mask-price'), function() {
			$(this).val($(this).cleanVal());
		});
	});


// Одинаковая высота блоков
$('.equal').matchHeight();


// Стилизация селектов
selectStyler($('.styler'));

setPriceMask();



// Дефолтные настройки magnificpopup
$.extend(true, $.magnificPopup.defaults, {
	tClose: 'Закрыть (Esc)',
	tLoading: 'Загрузка...',
	ajax: {
		tError: 'Контент не загружен.'
	}
});



function processStart(formData, jqForm) {
	laddaLoad = jqForm.find('.ladda-button').ladda();
	// $.ladda('stopAll');
	laddaLoad.ladda('start');

	return true;
}


function processDone(responseText, statusText, xhr, $form) {

	var $responseText = $(responseText),
		responseResult = ($responseText.is('form')) ? $responseText.html() : responseText;

	var progress = 0;
	var interval = setInterval(function () {
		progress = Math.min(progress + Math.random() * 0.2, 1);
		laddaLoad.ladda('setProgress', progress);

		if (progress === 1) {
			laddaLoad.ladda('stop');
			clearInterval(interval);

			// Тут что-то делаем с пришедшими данными
			if (statusText == 'success') {
				$form.html(responseResult).find('.equal').matchHeight();
				selectStyler($form.find('.styler'));
				setPriceMask();

			}
		}
	}, 100);
}

function selectStyler(obj) {
	obj.styler({
		selectSearch: true,
		selectSearchLimit: 10,
		onFormStyled: function () {
			$('.jq-selectbox').addClass('opacity-one');
		}
	});
}

function setPriceMask() {
	// Маска для цены
	$('.input-mask-price').mask('### ### ###.00', {
		reverse: true
	});
}

/**
 * Простой js-шаблонизатор
 * 
 * Установка шаблона:
 *  <template id="tpl">
 *      <ul>
 *          {% for(var i in this.items) { %}
 *              <li>
 *                  <b>{% this.items[i].name %}</b>
 *              </li>
 *          {% } %}
 *      </ul>
 *  </template>
 * Использование: 
 * var template = document.getElementById('tpl').innerHTML;
 * var items = {0:{'name': 'one'}, 1: {'name': 'two'}};
 * var show = (simpleJsTemplater(template, {
				items: items
			}));
 * console.log(show);
 */

function simpleJsTemplater(html, options) {
	'use strict';
	var re = /\[%(.+?)%\]/g,
		reExp = /(^( )?(var|if|for|else|switch|case|break|{|}|;))(.*)?/g,
		code = 'with(obj) { var r=[];\n',
		cursor = 0,
		result,
		match;
	var add = function (line, js) {
		js ? (code += line.match(reExp) ? line + '\n' : 'r.push(' + line + ');\n') :
			(code += line !== '' ? 'r.push("' + line.replace(/"/g, '\\"') + '");\n' : '');
		return add;
	};
	while (match = re.exec(html)) {
		add(html.slice(cursor, match.index))(match[1], true);
		cursor = match.index + match[0].length;
	}
	add(html.substr(cursor, html.length - cursor));
	code = (code + 'return r.join(""); }').replace(/[\r\t\n]/g, '');
	try {
		result = new Function('obj', code).apply(options, [options]);
	}
	catch (err) {
		console.error("'" + err.message + "'", " in \n\nCode:\n", code, "\n");
	}
	return result;
}