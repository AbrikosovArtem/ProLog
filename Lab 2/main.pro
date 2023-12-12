implement main
    open core, stdio, file

domains
    course = appointment; doctor; patient; medication.

class facts - healthcareDB
    доктор : (integer DoctorId, string DoctorName, string Specialization) nondeterm.
    пациент : (integer PatientId, string PatientName, string Address, string PhoneNumber, integer Age) nondeterm.
    назначение : (integer DoctorId, integer PatientId, string Date, string Diagnosis, string Medication, boolean FollowUp) nondeterm.
    лечение : (string Medication, integer Cost) nondeterm.

class predicates
    пациент_с_диагнозом : (string Diagnosis) failure.
    список_врачей : (string Specialization) failure.
    стоимость_лекарства_для_пациента : (integer PatientId) failure.
    %средний_возраст_пациента : (integer AverageAge) nondeterm.
    %занятой_доктор : (string DoctorName) nondeterm.
    пациенты_в_возрастном_диапазоне : (integer MinAge, integer MaxAge) failure.
    доступные_доктора : (string Date) failure.
    аллергии_у_пациента : (integer PatientId) failure.
    врачи_без_назначения : (string Diagnosis) failure.

clauses
    пациент_с_диагнозом(Diagnosis) :-
        назначение(_, PatientId, _, Diagnosis, _, _),
        пациент(PatientId, PatientName, _, _, _),
        write(PatientName, Diagnosis),
        nl,
        fail.

    список_врачей(Specialization) :-
        доктор(_, DoctorName, Specialization),
        write(DoctorName, Specialization, "\n"),
        nl,
        fail.

    стоимость_лекарства_для_пациента(PatientId) :-
        назначение(_, PatientId, _, _, Medication, _),
        пациент(PatientId, PatientName, _, _, _),
        лечение(Medication, Cost),
        write("Пациент: ", PatientName, " Стоимость лекарств: ", Cost),
        nl,
        fail.

    пациенты_в_возрастном_диапазоне(MinAge, MaxAge) :-
        пациент(_PatientId, PatientName, _, _, Age),
        Age >= MinAge,
        Age <= MaxAge,
        write(PatientName, Age),
        nl,
        fail.

    доступные_доктора(Date) :-
        доктор(DoctorId, DoctorName, Specialization),
        назначение(DoctorId, _, Date, _, _, _),
        write(DoctorName, Specialization),
        nl,
        fail.

    аллергии_у_пациента(PatientId) :-
        назначение(_, PatientId, _, _, Medication, _),
        лечение(Medication, _),
        write(PatientId),
        nl,
        fail.

    врачи_без_назначения(Diagn) :-
        доктор(DoctorId, DoctorName, _Specialization),
        назначение(DoctorId, _, Date, Diagnosis, _, _),
        Diagn <> Diagnosis,
        write(DoctorName, Date, Diagnosis),
        nl,
        fail.
        /*
    список_врачей(DoctorName, Specialization) :-
        доктор(_, DoctorName, Specialization),
        assert(колличество_врачей(1)),
        nl,
        fail.

    колличество_врачей(Count) :-
        retractall(колличество_врачей(_)),
        Doctors = [ _ || список_врачей(_, _) ],
        length(Doctors, Count),
        nl,
        fail.
    */

clauses
    run() :-
        consult("../data.txt", healthcareDB),
        fail.

    run() :-
        write("\nПациенты с диагнозом Лихорадка: "),
        пациент_с_диагнозом("Лихорадка"),
        fail.

    run() :-
        Specialization = "Педиатр",
        write("\nВрачи педиатры: "),
        список_врачей(Specialization),
        fail.

    run() :-
        стоимость_лекарства_для_пациента(1),
        fail.

    run() :-
        write("\nПациенты в возрастном диапазоне 25-35: "),
        пациенты_в_возрастном_диапазоне(25, 35),
        fail.

    run() :-
        write("\nДоступные врачи на 2023-12-15: "),
        доступные_доктора("2023-12-15"),
        fail.

    run() :-
        аллергии_у_пациента(2),
        fail.

    run() :-
        врачи_без_назначения("Кашель"),
        fail.
        /*
    run() :-
        список_врачей(DoctorName, Specialization),
        write("\nдоктор: ", DoctorName, " специализация: ", Specialization),
        nl,
        fail.

    run() :-
        колличество_врачей(TotalDoctors),
        write("\nвсего врачей: ", TotalDoctors),
        nl,
        fail.
    */
    run().

end implement main

goal
    console::runUtf8(main::run).
