INSERT INTO regiao VALUES (1, 'Lisboa', 2821697);
INSERT INTO regiao VALUES (2, 'Norte',	3689609);
INSERT INTO regiao VALUES (3, 'Centro', 2327026);
INSERT INTO regiao VALUES (4, 'Alentejo', 17);
INSERT INTO regiao VALUES (5, 'Algarve', 24);


INSERT INTO concelho VALUES (1, 3,'Torres Vedras', 30000);
INSERT INTO concelho VALUES (2, 3, 'Tomar', 40677);
INSERT INTO concelho VALUES (3, 1, 'Lisboa',  506892);
INSERT INTO concelho VALUES (4, 3, 'Figueira da Foz', 600);
INSERT INTO concelho VALUES (5, 3, 'Lourinha', 60014);
INSERT INTO concelho VALUES (6, 3, 'Leiria', 126897);
INSERT INTO concelho VALUES (7, 2, 'Porto', 200000);


INSERT INTO instituicao VALUES ('Hospital Santa Maria', 'hospital', 1, 3);
INSERT INTO instituicao VALUES ('Laboratorio Beatriz Godinho', 'laboratorio', 3, 6);
INSERT INTO instituicao VALUES ('Farmacia do Hospital', 'farmacia', 1, 3);
INSERT INTO instituicao VALUES ('Clinica Malo', 'clinica', 1, 3);
INSERT INTO instituicao VALUES ('Hospital do Porto', 'hospital', 2, 7);


INSERT INTO medico VALUES (1, 'Maria', 'obstetricia');
INSERT INTO medico VALUES (2, 'Freddy', 'medico de familia');
INSERT INTO medico VALUES (3, 'Ines', 'urologista');
INSERT INTO medico VALUES (4, 'Noah Centino', 'dermatologista');
INSERT INTO medico VALUES (5, 'Renata', 'neurocirurgia');


INSERT INTO consulta VALUES (1, 5, '2020-12-11', 'Hospital Santa Maria');
INSERT INTO consulta VALUES (2, 1, '2020-10-01', 'Laboratorio Beatriz Godinho');
INSERT INTO consulta VALUES (3, 2, '2020-01-30', 'Farmacia do Hospital');
INSERT INTO consulta VALUES (4, 3, '2020-02-28', 'Clinica Malo');
INSERT INTO consulta VALUES (5, 4, '2020-08-27', 'Hospital do Porto');


INSERT INTO prescricao VALUES (5, 4, '2020-08-27', 'metamizol magnesico', 5.5);
INSERT INTO prescricao VALUES (1, 5, '2020-12-11', 'valeriana', 20.0);
INSERT INTO prescricao VALUES (3, 2, '2020-01-30', 'cetrizina', 2.8);
INSERT INTO prescricao VALUES (4, 3, '2020-02-28', 'paracetamol', 1.9);
INSERT INTO prescricao VALUES (2, 1, '2020-10-01', 'ibruprofeno', 0.4);


INSERT INTO analise VALUES (1, 'obstretricia', 1, 5, '2020-12-11', '2020-12-15', 'Analise ao sangue', 1, 'Hospital Santa Maria');
INSERT INTO analise VALUES (2, 'medico de familia', 2, 1, '2020-10-01', '2020-10-31', 'Analise à tensão', 100, 'Laboratorio Beatriz Godinho');
INSERT INTO analise VALUES (3, 'urologista', 3, 2, '2020-01-30', '2020-01-31', 'Analise a urina', 1, 'Farmacia do Hospital');
INSERT INTO analise VALUES (4, 'dermatologista', 4, 3, '2020-02-28', '2020-02-29', 'Analise a ferritina', 20, 'Hospital Santa Maria');
INSERT INTO analise VALUES (5, 'neurologia', 5, 4, '2020-08-27', '2020-08-30', 'Analise ao cabelo', 1, 'Hospital Santa Maria');


INSERT INTO venda_farmacia VALUES (1, '2020-11-17', 'ibruprofeno', 20, 100, 'Farmacia do Hospital');
INSERT INTO venda_farmacia VALUES (2, '2020-11-17', 'cetrizina', 1, 5, 'Laboratorio Beatriz Godinho');
INSERT INTO venda_farmacia VALUES (3, '2020-11-17', 'valeriana', 15, 2, 'Hospital Santa Maria');
INSERT INTO venda_farmacia VALUES (4, '2020-11-17', 'substancia1', 7, 90, 'Clinica Malo');
INSERT INTO venda_farmacia VALUES (5, '2020-11-17', 'substancia2', 9, 4, 'Hospital do Porto');
INSERT INTO venda_farmacia VALUES (6, '2020-11-17', 'substancia3', 16, 1, 'Farmacia do Hospital');


INSERT INTO prescricao_venda VALUES (5, 4, '2020-08-27', 'metamizol magnesico', 1);
INSERT INTO prescricao_venda VALUES (1, 5, '2020-12-11', 'valeriana', 2);
INSERT INTO prescricao_venda VALUES (3, 2, '2020-01-30', 'cetrizina', 3);
-- INSERT INTO prescricao_venda VALUES (4, 3, '2020-02-28', 'paracetamol', 4);
-- INSERT INTO prescricao_venda VALUES (2, 1, '2020-10-01', 'ibuprofeno', 5);