﻿% Факты о пациентах
пациент(иван_петров, кардиология).
пациент(мария_сидорова, терапия).
пациент(алексей_иванов, офтальмология).

% Факты о врачах
врач(доктор_смирнов, кардиолог).
врач(доктор_попова, терапевт).
врач(доктор_козлова, офтальмолог).

% Факты о расписании приема
расписание(понедельник, кардиология, 10:00, 14:00).
расписание(вторник, терапия, 9:30, 12:30).
расписание(среда, офтальмология, 11:00, 15:00).

% Факты о болезнях и лекарствах
болезнь(иван_петров, гипертония).
болезнь(мария_сидорова, грипп).
болезнь(алексей_иванов, катаракта).

лекарство(гипертония, анаприлин).
лекарство(грипп, терафлю).
лекарство(катаракта, операция).

% Правило для определения, в какой день и время пациент может записаться к врачу
записаться_к_врачу(Пациент, Врач, День, Время) :-
    пациент(Пациент, Специализация),
    врач(Врач, Специализация),
    расписание(День, Специализация, Начало, Конец),
    Время >= Начало,
    Время =< Конец.

% Правило для проверки, свободен ли врач в определенный день и время
свободен_врач(Врач, День, Время) :-
    врач(Врач, _),
    not(записаться_к_врачу(_, Врач, День, Время)).

% Правило для вывода списка доступных врачей в определенный день и время
доступные_врачи(День, Время, Список_Врачей) :-
    findall(Врач, свободен_врач(Врач, День, Время), Список_Врачей).

% Правило для определения лекарства, которое нужно выписать пациенту
лечение(Пациент, Лекарство) :-
    болезнь(Пациент, Болезнь),
    лекарство(Болезнь, Лекарство).

% Правило для вывода списка пациентов, нуждающихся в операции
операция_нужна(Пациент) :-
    болезнь(Пациент, катаракта).

% Правило для вывода списка пациентов, имеющих определенное лекарство
пациенты_с_лекарством(Лекарство, Список_Пациентов) :-
    findall(Пациент, лечение(Пациент, Лекарство), Список_Пациентов).