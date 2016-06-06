
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
		};
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
					selecStyler($(this.content).find('.styler'));
					$(this.content).find('.equal').matchHeight();
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
		var key = $(this).data('addListField'),
			$field = $('<div class="content"><div class="col col-mb-12 col-4 col-dt-4"><input class="input input-block input-mask-latin" type="text" name="default_value[' + key + '][value]" placeholder="Значение" required></div><div class="col col-mb-12 col-5 col-dt-6"><input class="input input-block" type="text" name="default_value[' + key + '][label]" placeholder="Отображаемый текст"></div><div class="col col-mb-12 col-3 col-dt-2"><span class="btn btn-secondary btn-outline btn-block fz14 pl0 pr0" data-remofe-list-field title="Удалить текущее поле"><i class="icon-cross"></i> Удалить</span></div><div class="col col-mb-12 col-mb-block col-hide col-dt-hide col-ld-hide"><hr ></div></div>');

		$field.insertBefore($(this)).find('[name="default_value[' + key + '][value]"]').focus();
		$(this).data('addListField', key + 1);
	})
	.on('click', '[data-remofe-list-field]', function (e) {
		e.preventDefault();
		$(this).closest('.content').remove();
	})
	.on('input', '.input-mask-latin', function () {
		if (this.value.match(/[^a-zA-Z0-9_\s]/g)) {
			this.value = this.value.replace(/[^a-zA-Z0-9_\s]/g, '_');
		}
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
	});


// Одинаковая высота блоков
$('.equal').matchHeight();


$.simpleMobileNav({
	navBlock: '.left-nav',
	navContainer: '.mobile-nav',
	navWrapper: '.mobile-nav-wrapper',
	// Колбэки раскомментировать при необходимости
	onInit: function (nav) {
		var $ul = $(nav).find('.left-nav');

		$ul.removeClass('left-nav');
	},
	// onNavToggle: function (nav) {
	// 	console.log('onNavToggle: ', this, nav);
	// },
	// beforeNavOpen: function (nav) {
	// console.log('beforeNavOpen: ', this, nav);
	// },
	// beforeNavClose: function (nav) {
	// 	console.log('beforeNavClose: ', this, nav);
	// }
});

// Стилизация селектов
selecStyler($('.styler'));



// Дефолтные настройки magnificpopup
$.extend(true, $.magnificPopup.defaults, {
	tClose: 'Закрыть (Esc)',
	tLoading: 'Загрузка...',
	ajax: {
		tError: 'Контент не загружен.'
	}
});

// Маска для цены
$('.input-mask-price').mask('### ### ###.00', {
	reverse: true
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
				$form.html(responseResult).find('.equal').matchHeight();;
				selecStyler($form.find('.styler'));
			}
		}
	}, 100);
}

function selecStyler(obj) {
	obj.styler({
		selectSearch: true,
		selectSearchLimit: 10,
		onFormStyled: function () {
			$('.jq-selectbox').addClass('opacity-one');
		}
	});
}