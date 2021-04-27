﻿#Область Форма

#Область События

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВосстановитьСостояниеРаботы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.СтраницаОбновленияЕсть.Видимость = Ложь;
	Элементы.СтраницаОбновленийНет.Видимость  = Ложь;
	Элементы.СтраницаВводПинКода.Видимость    = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Попытка
		СохранитьСостояниеРаботы();
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область Элементы

&НаКлиенте
Процедура ПинКодПользователяПриИзменении(Элемент)
	
	//
	
КонецПроцедуры

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура КомандаЗагрузитьНовуюВерсию(Команда)
	
	ЗагрузитьНовуюВерсиюНавигатора();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПроверитьНаличиеОбновлений(Команда)
	
	Если Не ЗначениеЗаполнено(ПинКодПользователя) Тогда
		ПоказатьПредупреждение(, "Не указан код доступа для проверки наличия обновлений.", , "Навигатор");
		Возврат;
	КонецЕсли;
	
	ПроверитьНаличиеОбновлений();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Процедуры

&НаКлиенте
Процедура ПроверитьНаличиеОбновлений(ЕстьОбновления = Ложь)
	
	ЕстьОбновления = Ложь;
	
	ПараметрыПолучения = ПараметрыПолученияОбновлений();
	
	Если ПараметрыПолучения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//
	
	ИмяИнфоФайла = ИмяФайлаОписанияОбновлений(ПараметрыПолучения);
	
	Если Не ЗначениеЗаполнено(ИмяИнфоФайла) Тогда
		Возврат;
	КонецЕсли;
	
	//
	
	ИмяИнфоФайлаКл = ПолучитьИмяВременногоФайла("txt");
	НачатьКопированиеФайла(Новый ОписаниеОповещения("ПроверитьНаличиеОбновленийЗавершение", ЭтаФорма), ИмяИнфоФайла, ИмяИнфоФайлаКл);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеОбновленийЗавершение(СкФайл, ДпПараметры) Экспорт
	
	ТекстФайла = Новый ТекстовыйДокумент;
	ТекстФайла.НачатьЧтение(Новый ОписаниеОповещения("ПроверитьНаличиеОбновленийЗавершениеЧтения", ЭтаФорма, Новый Структура("ТекстФайла, СкФайл", ТекстФайла, СкФайл)), СкФайл);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеОбновленийЗавершениеЧтения(ДпПараметры) Экспорт
	
	ЕстьОбновления = Ложь;
	
	ДанныеОбновления = ДанныеОбновленияПрограммы(ДпПараметры.ТекстФайла);
	
	Если Не (ДанныеОбновления = Неопределено) Тогда
		
		ТекНомерВерсии = НомерВерсииОбработки();
		
		Если ЭтоНоваяВерсияОбработки(ТекНомерВерсии, ДанныеОбновления.НомерВерсии) Тогда
			
			ВывестиОписаниеИзменений(ДанныеОбновления);
			
			//
			
			ТекстВерсияПодробно = 
				Новый ФорматированнаяСтрока(
					"Доступна версия ", Новый ФорматированнаяСтрока(ДанныеОбновления.НомерВерсии, Новый Шрифт(, , Истина)),
					Новый ФорматированнаяСтрока(". У вас установлена версия "),
					Новый ФорматированнаяСтрока(ТекНомерВерсии, Новый Шрифт(, , Истина)),
					Новый ФорматированнаяСтрока(". Хотите загрузить новую версию?")
				);
			
			Элементы.НадписьВерсияПодробно.Заголовок = ТекстВерсияПодробно;
			
			ЕстьОбновления = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.СтраницаОбновленияЕсть.Видимость = ЕстьОбновления;
	Элементы.СтраницаОбновленийНет.Видимость = Не ЕстьОбновления;
	Элементы.СтраницаВводПинКода.Видимость = Ложь;
	
	НачатьУдалениеФайлов(Новый ОписаниеОповещения("ПроверитьНаличиеОбновленийЗавершениеУдаленияФайлов", ЭтаФорма), ДпПараметры.СкФайл);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеОбновленийЗавершениеУдаленияФайлов(ДпПараметры) Экспорт
	//
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНовуюВерсиюНавигатора()
	
	ЭтоВнешняя = ЭтоВнешняяОбработка();
	
	ВыборКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ВыборКаталога.Заголовок = "Сохранять полученную обработку в каталог";
	ВыборКаталога.Показать(Новый ОписаниеОповещения("ЗагрузитьНовуюВерсиюНавигатораЗавершение", ЭтаФорма));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНовуюВерсиюНавигатораЗавершение(ВыбФайлы, ДпПараметры) Экспорт
	
	#Область Предусловия
	
	Если (ВыбФайлы = Неопределено) Тогда
		Возврат;
	КонецЕсли;
	
	#КонецОбласти
	
	ИмяКаталога = ВыбФайлы[0] + "\";
	
	Если Не ЗначениеЗаполнено(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОбновления = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ПараметрыПолучения = ПараметрыПолученияОбновлений();
	
	ИмяФайлаНовойВерсии = ИмяФайлаНовойВерсииОбработки(ПараметрыПолучения);
	
	Если Не ЗначениеЗаполнено(ИмяФайлаНовойВерсии) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайлаДляКопирования = ИмяФайлаНовойВерсииОбработкиДляКопирования();
	
	Попытка
		КопироватьФайл(ИмяФайлаНовойВерсии, ИмяКаталога + ИмяФайлаДляКопирования);
	Исключение
		
		ТекстОшибки = ОписаниеОшибки();
		ТекстПояснения = 
			"При загрузке новой версии обработки произошла ошибка.
			|Описание ошибки: '" + ТекстОшибки + "'";
		
		ПоказатьОповещениеПользователя("Загрузка новой версии:", , ТекстПояснения, Элементы.КартинкаОшибка.Картинка);
		
		Возврат;
		
	КонецПопытки;
	
	ПоказатьОповещениеПользователя(
		"Загрузка новой версии:", 
		Новый ОписаниеОповещения(
				"ЗагрузитьНовуюВерсиюНавигатораОткрытьКаталог", 
				ЭтаФорма, 
				Новый Структура("ИмяКаталога", ИмяКаталога)
			), 
		"Версия " + ДанныеОбновления.НомерВерсии + " успешно загружена.
		|Файл: " + ИмяФайлаДляКопирования, 
		Элементы.КартинкаЗеленаяГалка.Картинка
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНовуюВерсиюНавигатораОткрытьКаталог(ДпПараметры) Экспорт
	
	#Область Предусловия
	
	Если ДпПараметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#КонецОбласти
	
	ЗапуститьПриложение(ДпПараметры.ИмяКаталога);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиОписаниеИзменений(ДанныеОбновления)
	
	ОписаниеИзменений.Очистить();
	ОписаниеИзменений.Область(, 1, , 1).ШиринаКолонки = 1;
	ОписаниеИзменений.Область(, 2, , 2).ШиринаКолонки = 70;
	ОписаниеИзменений.Область(, 2, , 2).РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	
	НомерСтроки = 1;
	ОписаниеИзменений.Область(НомерСтроки, 1).Текст = "Изменения:";
	//ОписаниеИзменений.Область(НомерСтроки, 1).Шрифт = Новый Шрифт(, , 6, Истина);
	
	Для каждого ТекстИзменения Из ДанныеОбновления.Изменения Цикл
		НомерСтроки = НомерСтроки + 1;
		ОписаниеИзменений.Область(НомерСтроки, 2).Текст = ТекстИзменения;
		//ОписаниеИзменений.Область(НомерСтроки, 2).Шрифт = Новый Шрифт(, , 6);
	КонецЦикла;
	
	НомерСтроки = НомерСтроки + 2;
	ОписаниеИзменений.Область(НомерСтроки, 1).Текст = "Исправления:";
	//ОписаниеИзменений.Область(НомерСтроки, 1).Шрифт = Новый Шрифт(, , 6, Истина);
	
	Для каждого ТекстИсправления Из ДанныеОбновления.Исправления Цикл
		НомерСтроки = НомерСтроки + 1;
		ОписаниеИзменений.Область(НомерСтроки, 2).Текст = ТекстИсправления;
		//ОписаниеИзменений.Область(НомерСтроки, 2).Шрифт = Новый Шрифт(, , 6);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьСостояниеРаботы()
	
	Если ЗначениеЗаполнено(ПинКодПользователя) Тогда
		
		КлючОбъекта = "Навигатор1С_Обновления";
		КлючНастроек = "ПинКодПользователя";
		НастройкиПинКодПользователя = ПинКодПользователя;
		
		ХранилищеОбщихНастроек.Сохранить(КлючОбъекта, КлючНастроек, НастройкиПинКодПользователя);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьСостояниеРаботы()
	
	КлючОбъекта = "Навигатор1С_Обновления";
	КлючНастроек = "ПинКодПользователя";
	ПинКодПользователя = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта, КлючНастроек);
	
КонецПроцедуры

#КонецОбласти

#Область Функции

&НаКлиенте
Функция ДанныеОбновленияПрограммы(ИнфоТекстОбновления)
	
	Результат = Тип_ДанныеОбновленияПрограммы();
	ПустойРезультат = Неопределено;
	
	#Область Предусловия
	
	Если Не ЗначениеЗаполнено(ИнфоТекстОбновления.ПолучитьТекст()) Тогда
		Возврат ПустойРезультат;
	КонецЕсли;
	
	#КонецОбласти
	
	ДанныеОбновления = Тип_ДанныеОбновленияПрограммы();
	ДанныеОбновления.НомерВерсии = ИнфоТекстОбновления.ПолучитьСтроку(1);
	
	КоличествоСтрок = ИнфоТекстОбновления.КоличествоСтрок();
	
	ЧтИзменения = Ложь;
	ЧтИсправления = Ложь;
	
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		
		СтрокаТекста = СокрЛП(ИнфоТекстОбновления.ПолучитьСтроку(НомерСтроки));
		
		Если Не ЗначениеЗаполнено(СтрокаТекста) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаТекста = "#Изменения" Тогда
			ЧтИзменения = Истина;
			Продолжить;
		КонецЕсли;
		
		Если СтрокаТекста = "#Исправления" Тогда
			ЧтИзменения = Ложь;
			ЧтИсправления = Истина;
			Продолжить;
		КонецЕсли;
		
		Если ЧтИзменения Тогда
			ДанныеОбновления.Изменения.Добавить(СтрокаТекста);
		ИначеЕсли ЧтИсправления Тогда
			ДанныеОбновления.Исправления.Добавить(СтрокаТекста);
		КонецЕсли;
		
	КонецЦикла;
	
	//
	
	Результат = ДанныеОбновления;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЭтоНоваяВерсияОбработки(ТекНомерВерсии, НомерВерсииОбработки)
	
	#Область Предусловия
	
	Если Не ЗначениеЗаполнено(ТекНомерВерсии) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерВерсииОбработки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СокрЛП(ТекНомерВерсии) = СокрЛП(НомерВерсииОбработки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	#КонецОбласти
	
	ЭтоНоваяВерсия = Ложь;
	
	ЭтаОбработка = ЭтаОбработка();
	
	ЧастиТекНомерВерсии       = ЭтаОбработка.РазложитьСтрокуВМассивПодстрок(ТекНомерВерсии, ".");
	ЧастиНомерВерсииОбработки = ЭтаОбработка.РазложитьСтрокуВМассивПодстрок(НомерВерсииОбработки, ".");
	
	// Сравнить части.
	
	ГраницаМассива = ЧастиТекНомерВерсии.ВГраница();
	
	// 2.1.1.13
	// 2.1.1.14
	
	Для Индекс = 0 По ГраницаМассива Цикл
		
		Если Индекс = 0 Тогда
			Если Число(ЧастиТекНомерВерсии[Индекс]) > Число(ЧастиНомерВерсииОбработки[Индекс]) Тогда
				Возврат Ложь;
			КонецЕсли;
		Иначе
			
			Если Число(ЧастиТекНомерВерсии[Индекс - 1]) = Число(ЧастиНомерВерсииОбработки[Индекс - 1]) И 
				Число(ЧастиТекНомерВерсии[Индекс]) > Число(ЧастиНомерВерсииОбработки[Индекс]) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЭтоВнешняяОбработка()
	
	Возврат ЭтаОбработка().ЭтоВнешняяОбработка();
	
КонецФункции

&НаСервере
Функция ПараметрыПолученияОбновлений()
	
	Результат = Неопределено;
	ПсРезультат = Неопределено;
	
	ПараметрыОбновлений = ЭтаОбработка().ПараметрыПолученияОбновлений();
	
	Если ПараметрыОбновлений = Неопределено Тогда
	
		Если Не ЗначениеЗаполнено(ПинКодПользователя) Тогда
			Возврат ПсРезультат;
		КонецЕсли;
		
		// Есть пин-код пользователя.
		
		ПараметрыОбновлений = Новый Структура("ПинКод, КодАктивации", "", "");
		ПараметрыОбновлений.ПинКод       = Лев(ПинКодПользователя, Найти(ПинКодПользователя, "~") - 1);
		ПараметрыОбновлений.КодАктивации = Сред(ПинКодПользователя, Найти(ПинКодПользователя, "~") + 1);
		
	КонецЕсли;
	
	Результат = ПараметрыОбновлений;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИмяФайлаНовойВерсииОбработкиДляКопирования()
	
	Результат = "";
	ПустойРезультат = "";
	
	ЭтаОбработка = ЭтаОбработка();
	
	#Область Предусловия
	
	ПараметрыПолучения = ПараметрыПолученияОбновлений();
	
	Если ПараметрыПолучения = Неопределено Тогда
		Возврат ПустойРезультат;
	КонецЕсли;
	
	Если ДанныеОбновления = Неопределено Тогда
		Возврат ПустойРезультат;
	КонецЕсли;
	
	#КонецОбласти
	
	ЧастиНомераВерсии = ЭтаОбработка.РазложитьСтрокуВМассивПодстрок(ДанныеОбновления.НомерВерсии, ".");
	
	НомерВерсииДляПодстановки = ЭтаОбработка.ПодставитьПараметрыВСтроку(
		"%1_%2_%3_%4", 
		ЧастиНомераВерсии[0],
		ЧастиНомераВерсии[1],
		ЧастиНомераВерсии[2],
		ЧастиНомераВерсии[3]
	);
	
	Результат = ЭтаОбработка.ПодставитьПараметрыВСтроку("Навигатор_%1.epf", НомерВерсииДляПодстановки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИмяФайлаНовойВерсииОбработки(ПараметрыПолучения)
	
	Результат = "";
	ПустойРезультат = "";
	
	ЭтаОбработка = ЭтаОбработка();
	
	#Область Предусловия
	
	Если ДанныеОбновления = Неопределено Тогда
		Возврат ПустойРезультат;
	КонецЕсли;
	
	#КонецОбласти
	
	ЧастиНомераВерсии = ЭтаОбработка.РазложитьСтрокуВМассивПодстрок(ДанныеОбновления.НомерВерсии, ".");
	
	НомерВерсииДляПодстановки = ЭтаОбработка.ПодставитьПараметрыВСтроку(
		"%1_%2_%3_%4", 
		ЧастиНомераВерсии[0],
		ЧастиНомераВерсии[1],
		ЧастиНомераВерсии[2],
		ЧастиНомераВерсии[3]
	);
	
	Результат = ЭтаОбработка.ПодставитьПараметрыВСтроку(
		"https://%1:%2@webdav.yandex.ru/Навигатор_%3.epf", 
		ПараметрыПолучения.ПинКод, 
		ПараметрыПолучения.КодАктивации,
		НомерВерсииДляПодстановки
	);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ИмяФайлаОписанияОбновлений(ПараметрыПолучения)
	
	Результат = "";
	ПустойРезультат = "";
	
	ЭтаОбработка = ЭтаОбработка();
	
	Результат = ЭтаОбработка.ПодставитьПараметрыВСтроку(
		"https://%1:%2@webdav.yandex.ru/ver.txt", 
		ПараметрыПолучения.ПинКод, 
		ПараметрыПолучения.КодАктивации
	);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция НомерВерсииОбработки()
	Возврат ЭтаОбработка().НомерВерсииОбработки();
КонецФункции

&НаСервере
Функция ЭтаОбработка()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Тип_ДанныеОбновленияПрограммы()
	
	Результат = Новый Структура;
	Результат.Вставить("НомерВерсии", "");
	Результат.Вставить("Изменения",   Новый Массив);
	Результат.Вставить("Исправления", Новый Массив);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти