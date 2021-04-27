﻿// Проверяет наличие реквизита или свойства у произвольного объекта без обращения к метаданным.
//
// Параметры:
//  Объект       - Произвольный - объект, у которого нужно проверить наличие реквизита или свойства;
//  ИмяРеквизита - Строка       - имя реквизита или свойства.
//
// Возвращаемое значение:
//  Булево.
//
&НаКлиентеНаСервере
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

// Возвращает значение свойства структуры.
//
// Параметры:
//   Структура - Структура, ФиксированнаяСтруктура - Объект, из которого необходимо прочитать значение ключа.
//   Ключ - Строка - Имя свойства структуры, для которого необходимо прочитать значение.
//   ЗначениеПоУмолчанию - Произвольный - Необязательный. Возвращается когда в структуре нет значения по указанному
//                                        ключу.
//       Для скорости рекомендуется передавать только быстро вычисляемые значения (например примитивные типы),
//       а инициализацию более тяжелых значений выполнять после проверки полученного значения (только если это
//       требуется).
//
// Возвращаемое значение:
//	Произвольный - Значение свойства структуры. ЗначениеПоУмолчанию если в структуре нет указанного свойства.
//
&НаКлиентеНаСервере
Функция СвойствоСтруктуры(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	
	Если Структура = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Если Не (ТипЗнч(Структура) = Тип("Структура")) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Результат = ЗначениеПоУмолчанию;
	
	Если Структура.Свойство(Ключ, Результат) Тогда
		Возврат Результат;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
КонецФункции