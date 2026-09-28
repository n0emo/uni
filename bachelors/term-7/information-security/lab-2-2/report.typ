#import "../common.typ": *

#show: report.with(
  number: "2.2",
  title: "Использование криптографических сервис-провайдеров при решении задач профессиональной деятельности. Симметричное шифрование. Исследование статистических свойств открытого и зашифрованного текста",
)

= Задание

+ Разработать на языке Go приложение, которое выполняет следующие функции:
  - выбор алгоритма симметричного шифрования пользователем по названию (варианты: RC2, RC4, RC5,
    DES, DESede, AES);
  - генерацию симметричного ключа для выбранного алгоритма шифрования;
  - зашифрования произвольного сообщения;
  - расшифрование сообщения;
  - расчет средней энтропии байта в открытом тексте;
  - расчет средней энтропии байта в зашифрованном тексте.
+ Выполнить тестирование приложения.
  + Выбрать произвольное короткое сообщение.
  + Измерить среднюю энтропию байта в сообщении.
  + Выбирая поочерёдно каждый из предложенных методов шифрования:
    - зашифровать сообщение, измерить среднюю энтропию байта в шифртексте;
    - расшифровать сообщение, проверить правильность результата;
    - ответить на вопрос, как изменилась средняя энтропия байта в результате шифрования и как это
      характеризует качество шифрования.
  + Выбрать произвольное сообщение в два раза длиннее предыдущего. Выполнить над ним действия,
    описанные в пунктах 2.2, 2.3.
  + Выбрать произвольное сообщение в четыре раза длиннее предыдущего. Выполнить над ним действия,
    описанные в пунктах 2.2, 2.3.
  + Сделать вывод о том, как повлияла длина сообщения на полученные статистические характеристики
    шифртекстов.

= Выполнение

== Исходный текст программы

В ходе выполнения лабораторной работы разработано программное обеспечение на языке программирования
Go. Следует отметить, что вместо использования блочных шифров напрямую, программное обеспечение
создаёт потоковый шифр на основе выбранного блочного, что в целом приведёт к увеличению энтропии
зашифрованного текста. Исходный текст которого выглядит следующим образом:

#code-file(read("./src/main.go"), name: "main.go")

== Результат тестирования разработанного программного обеспечения

Результат шифрования сообщения «He мысля гордый свет забавить», средняя энтропия байта в котором
составляет 3.844 бит.

#figure(
  caption: "Статистика шифрования короткого сообщения",
  table(
    columns: 3,
    table.header([Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в шифртексте, бит]),
    [RC2],
    [`qFxHRA7SErndQjFUa8FXdr4CGSxfR6l4Iv_felnsBzLRPoYLbe9PEq-4lRPsw5sWdJnC`],
    [5.614712907393384],

    [RC4],
    [`5NXBDV9q4IF-d_QnEqx5zRcNsK4ZCZ6LimhIvXgPsOet1asjSeYWdEUz_e859qCtIduG`],
    [5.576977058336781],

    [RC5],
    [`yneGjvixCyv0dd1WVpU_ndC-0YDQtNGL0Lkg0YHQstC10YIg0LfQsNCx0LDQstC40YLR`],
    [4.4908728543870255],

    [DES],
    [`_xKBDvRJf2z0gYe1eXM47YDRoxr2GQp3iWieoaq2Fdy6dLyP7T9_LkaTOlK49u6V6GE4`],
    [5.501505360223574],

    [DESede],
    [`2Aa51Od9vMPp520CzDcI2Z7_9skkl-gfwPdD89AcK8DoUrmXptEGoF4ZtmBtLcTdmUZn`],
    [5.463769511166971],

    [AES],
    [`ejF47p_HwXBkDPP5vqEfU9fDze28EkT5xiW-HslzexRxEA1IFGmO63iSxzsZa4wsF3FG`],
    [5.501505360223574],
  ),
)

Вывод: RC2 показал наибольшее увеличение энтропии, в то время как RC5 --- наименьшее. Можно
предположить, что RC2 является самым качественным шифром.

Результат шифрования сообщения «He мысля гордый свет забавить, Вниманье дружбы возлюбя», средняя
энтропия байта в котором составляет 3.961 бит.

#figure(
  caption: "Статистика шифрования сообщения удвоенной длины",
  table(
    columns: 3,
    table.header([Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в шифртексте, бит]),
    [RC2],
    [`qFxHRA7SErndQjFUa8FXdr4CGSxfR6l4Iv_felnsBzLRPoYLbe9PEq-4lRPsw5sWdJnCuzsiu8OrvbCj2JN8mfG_eS5xv7cH_MiFjdMFr6tr5ioKhc9zK_PCR2w49goTuhiZ`],
    [6.250470003874293],

    [RC4],
    [`5NXBDV9q4IF-d_QnEqx5zRcNsK4ZCZ6LimhIvXgPsOet1asjSeYWdEUz_e859qCtIduGBMRVk2QFu7zrsdNB_siGeDmAH__8OoPzBCl9pfHfR5F-UgxqOyvOB-n4eCY-GPW6`],
    [6.399509271572916],

    [RC5],
    [`yneGjvixCyv0dd1WVpU_ndC-0YDQtNGL0Lkg0YHQstC10YIg0LfQsNCx0LDQstC40YLRjCwg0JLQvdC40LzQsNC90YzQtSDQtNGA0YPQttCx0Ysg0LLQvtC30LvRjtCx0Y8K`],
    [4.423797042715106],

    [DES],
    [`_xKBDvRJf2z0gYe1eXM47YDRoxr2GQp3iWieoaq2Fdy6dLyP7T9_LkaTOlK49u6V6GE4HLt_PdtNoT8kSXH_reVjjgPXC10rnsEtBd1pIPSCG82pbfaHAn36HAtVbGTTRMLE`],
    [6.242844877589815],

    [DESede],
    [`2Aa51Od9vMPp520CzDcI2Z7_9skkl-gfwPdD89AcK8DoUrmXptEGoF4ZtmBtLcTdmUZnrzcVe3dbFPMRB1bqr5XBfKh_aXT0tjIlXfJu1JLcn4BJJBzKkbj9-JX0AaUmRmsc`],
    [6.258095130158773],

    [AES],
    [`ejF47p_HwXBkDPP5vqEfU9fDze28EkT5xiW-HslzexRxEA1IFGmO63iSxzsZa4wsF3FGEQF-e8BDcSgGJpqhDuoDVMFGjVA97wmjoWWl9E2pSYZfjFrB0D57ficUpO0uqBeH`],
    [6.2073926048188355],
  ),
)

Вывод: все шифры, кроме RC5, увеличили энтропию и пришли примерно к одному результату в ≈6.3 бит.
RC5, в свою очередь, показал меньшую энтропию по сравнению с предыдущим результатом. Можно
предположить, что RC5 имеет самое низкое качество среди остальных.

Результат шифрования сообщения «He мысля гордый свет забавить, Вниманье дружбы возлюбя, Хотел бы я
тебе представить Залог достойнее тебя», средняя энтропия байта в котором составляет 3.897 бит.

#figure(
  caption: "Статистика шифрования сообщения учетверённой длины",
  table(
    columns: 3,
    table.header([Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в шифртексте, бит]),
    [RC2],
    [`qFxHRA7SErndQjFUa8FXdr4CGSxfR6l4Iv_felnsBzLRPoYLbe9PEq-4lRPsw5sWdJnCuzsiu8OrvbCj2JN8mfG_eS5xv7cH_MiFjdMFr6tr5ioKhc9zK_PCR2w49goTuhi_x2TeDlWyuzM49yHgppIIknXb-Hz-n22zY5y0xjkUq7jkTqbQc1iCrZztJKwVmgGKeWenzdVX-ERyifN6cWiiUNgFxN1XEJZmqQeoIY5SqP0LY-gwicFBojF5`],
    [6.990702450345122],

    [RC4],
    [`5NXBDV9q4IF-d_QnEqx5zRcNsK4ZCZ6LimhIvXgPsOet1asjSeYWdEUz_e859qCtIduGBMRVk2QFu7zrsdNB_siGeDmAH__8OoPzBCl9pfHfR5F-UgxqOyvOB-n4eCY-GPWclnw8sQ4zOEGEbqNv1vBqd7tbD7AWMjegXUWEKLII-koWf8pneqXpf2478VBBRddqhT7bDhZbWY604gsBglOqdQFFML0U6OdcikT9mNCYaxfceKQcheUsQSkV`],
    [6.976408832003776],

    [RC5],
    [`yneGjvixCyv0dd1WVpU_ndC-0YDQtNGL0Lkg0YHQstC10YIg0LfQsNCx0LDQstC40YLRjCwg0JLQvdC40LzQsNC90YzQtSDQtNGA0YPQttCx0Ysg0LLQvtC30LvRjtCx0Y8sINCl0L7RgtC10Lsg0LHRiyDRjyDRgtC10LHQtSBSrXfelNVQTqQktwUJBT-c0LjRgtGMINCX0LDQu9C-0LMg0LTQvtGB0YLQvtC50L3QtdC1INGC0LXQsdGP`],
    [4.575430736014608],

    [DES],
    [`_xKBDvRJf2z0gYe1eXM47YDRoxr2GQp3iWieoaq2Fdy6dLyP7T9_LkaTOlK49u6V6GE4HLt_PdtNoT8kSXH_reVjjgPXC10rnsEtBd1pIPSCG82pbfaHAn36HAtVbGTTRMLi6BIaKI_LHyrp-kP5Aa_gnSx1H-w4ZF0g0ilyhZCLgp1lemtk2_xmmNqDwn0HbxbE702kCxWbSlifKUCd_IGxJJMO1WRh4KVts89xPhJfuYCeqDVfgXMa2H2J`],
    [6.898545739796035],

    [DESede],
    [`2Aa51Od9vMPp520CzDcI2Z7_9skkl-gfwPdD89AcK8DoUrmXptEGoF4ZtmBtLcTdmUZnrzcVe3dbFPMRB1bqr5XBfKh_aXT0tjIlXfJu1JLcn4BJJBzKkbj9-JX0AaUmRms6HfYvWT0WRgmnSOB7s8bWlxBHZj-Fx096wu_5eEKftxQxJBOoDrjNLtRIAPP86pq2u4Qdm0NGvA1sE8Nl19gJdGG9n065rUpzkkMfT-xQwSFeTD_G9uP8dT67`],
    [6.965676726649521],

    [AES],
    [`ejF47p_HwXBkDPP5vqEfU9fDze28EkT5xiW-HslzexRxEA1IFGmO63iSxzsZa4wsF3FGEQF-e8BDcSgGJpqhDuoDVMFGjVA97wmjoWWl9E2pSYZfjFrB0D57ficUpO0uqBehhoU-_DoC2M9060YkfjGTQupS88YL4cPw1mlrUqdaM95HRMbYxxMq8w6RDUWzsouA33egLW4tDFDA5jzHZNWLDTgWGoiW2QRyn0-u5V9Vuj25rQAruvkZLNHq`],
    [6.894572647679382],
  ),
)

Вывод: результаты для данного сообщения полностью аналогичны результатам для предыдущего кроме того,
что средняя энтропия между всеми шифрами, кроме RC5, выросла до ≈6.9.

Результат шифрования полного текста произведения А.С. Пушкина «Евгений Онегин», средняя энтропия
байта в котором составляет 4.416 бит.

#figure(
  caption: "Статистика шифрования полного текста «Евгения Онегина»",
  table(
    columns: 3,
    table.header([Алгоритм шифрования], [Шифртекст], [Средняя энтропия байта в шифртексте, бит]),
    [RC2],
    table.cell(rowspan: 6)[Опущен в связи со слишком большим размером (≈600 килобайт)],
    [7.999384365363326],
    [RC4], [7.999410719029977],
    [RC5], [5.177961326745027],
    [DES], [7.999467776264637],
    [DESede], [7.999461947640753],
    [AES], [7.99948698718201],
  ),
)

Вывод: для достаточно большого по величине текста средняя энтропия зашифрованного текста всеми
алгоритмами, кроме RC5, примерно в 2 раза больше открытого и составила ≈8 бит. Это значение очень
близко к максимально возможному значению средней энтропии каждого байта. Каждый шифр, кроме RC5,
показал хорошее качество шифрование, если брать прирост средней энтропии байта в качестве метрики
качества.

Вывод о влиянии длины текста на полученные статистические характеристики шифртекстов: чем больше
длина открытого текста, тем выше средняя энтропия байта как для открытого, так и для зашифрованного
текста.
