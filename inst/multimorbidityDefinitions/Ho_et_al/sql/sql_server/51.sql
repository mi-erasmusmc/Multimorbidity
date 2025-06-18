CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 0 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (24296,25486,25757,26052,26361,26638,27235,28083,30346,31509,72566,74582,75488,76349,76914,76924,78093,79749,79758,80045,80340,81237,81239,132258,132565,132832,133147,133420,133424,133969,134290,134295,134579,135476,135489,135491,135750,136639,136915,136916,136917,137219,137800,137809,138074,138351,139750,139753,140046,140950,192255,192836,192847,193138,193418,193422,193719,193971,194589,195197,195480,195482,195483,196044,196047,196048,196049,196359,196360,197225,197500,197507,197799,197804,197806,197807,197808,198091,198104,198985,198988,199754,200051,200052,200054,200962,200963,201238,201517,201518,201519,201801,252840,254282,255192,256633,257503,258369,259748,259755,260336,261514,261808,316644,317801,372567,373151,374874,375490,376647,376918,377811,378696,379756,380055,380661,432254,432256,432257,432260,432262,432263,432264,432559,432833,432837,432838,432843,432844,432845,432848,433143,433148,433149,433423,433704,433709,433716,433973,433975,433976,434285,434289,434291,434292,434293,434577,434587,434588,434880,435190,435474,435478,435484,435487,435493,435751,435752,435755,436042,436050,436054,436344,436348,436352,436353,436357,436358,436635,436640,436643,436913,436919,436922,436923,436926,437220,437224,437498,437501,437798,437805,438080,438086,438089,438094,438360,438367,438368,438370,438692,438693,438694,438699,438977,438979,438982,439392,439404,439738,439739,439745,439746,440036,440047,440335,440339,440344,440345,440649,440658,440956,441223,441224,441225,441230,441233,441510,441513,441515,441520,441800,441802,441805,441806,441809,442122,442123,442126,442127,442131,442132,442134,442139,444203,600832,601104,601105,601106,601110,601112,601113,601124,601125,601126,601127,601128,601129,601130,601131,601132,601133,601134,601135,601136,601137,601138,601139,601140,601144,601145,601146,601147,601148,601149,601150,601152,601154,601155,601156,602102,602103,602193,603310,603311,605509,608064,608889,608892,608923,608924,609043,609044,609046,609047,609064,609065,609067,609180,609196,609197,609202,609203,609239,609305,609306,619299,619300,619301,619369,619378,619379,619380,619381,619382,619383,760999,761000,761001,762368,764936,764981,765123,3662037,4001318,4001319,4001320,4001321,4002340,4002342,4002345,4002348,4002352,4002353,4003028,4003173,4003175,4003179,4003674,4003675,4003683,4003694,4033890,4094409,4149322,4155169,4155170,4155171,4155172,4156114,4157320,4157454,4157456,4158563,4162115,4162117,4162119,4162120,4162122,4162253,4162859,4162860,4162861,4162862,4179720,4187850,4187851,4188545,4216273,4220184,4221964,4244491,4246013,4246014,4246015,4246016,4246017,4246018,4246019,4246020,4246021,4246022,4246023,4246024,4246025,4246026,4246027,4246028,4246029,4246030,4246031,4246032,4246033,4246034,4246035,4246036,4246037,4246039,4246040,4246042,4246120,4246121,4246122,4246124,4246125,4246126,4246128,4246130,4246131,4246133,4246134,4246135,4246136,4246137,4246138,4246139,4246140,4246141,4246142,4246143,4246144,4246146,4246147,4246148,4246224,4246225,4246226,4246227,4246228,4246229,4246230,4246231,4246232,4246233,4246234,4246235,4246236,4246237,4246238,4246239,4246240,4246241,4246243,4246245,4246246,4246248,4246249,4246793,4246794,4246795,4246796,4246797,4246798,4246799,4246800,4246801,4246802,4246803,4246804,4246805,4246807,4246808,4246809,4246810,4246922,4246923,4246924,4247227,4247228,4247229,4247230,4247232,4247233,4247236,4247237,4247238,4247239,4247241,4247242,4247331,4247332,4247335,4247336,4247337,4247338,4247339,4247340,4247341,4247345,4247346,4247347,4247348,4247349,4247350,4247351,4247352,4247353,4247354,4247355,4247356,4247357,4247358,4247360,4247361,4247716,4247719,4247720,4247723,4247724,4247725,4247726,4247727,4247821,4247822,4247823,4247824,4247825,4247826,4247828,4247829,4247830,4247831,4247832,4247834,4247835,4247836,4247837,4247838,4247839,4247840,4247841,4247842,4247843,4247844,4247846,4247847,4247849,4247850,4247851,4281019,4283748,4289388,4289392,4289681,4297711,4307721,4311474,4311475,4311476,4311477,4311478,4311479,4311480,4311481,4311483,4311485,4311486,4311487,4311488,4311489,4311490,4311491,4311492,4311493,4311496,4311497,4311498,4311499,4311500,4311501,4311502,4311612,4311614,4311617,4311618,4311619,4311620,4311621,4311625,4311626,4311627,4311628,4312004,4312032,4312033,4312565,4312566,4312567,4312675,4312676,4312677,4312680,4312681,4312682,4312683,4312684,4312685,4312686,4312687,4312688,4312689,4312690,4312691,4312692,4312693,4312694,4312695,4312698,4313056,35617803,35617871,35617882,35617893,35619970,35619980,35619986,35619990,36684472,36684473,36684817,36684818,36684819,36684820,36684821,36712933,36712934,36715789,36715801,36715852,36715857,36715858,36715859,36715860,36715865,36715888,36715891,36715913,36715914,36716492,36716493,36716499,36716500,36716501,36716505,36717179,37016123,37016124,37016439,37018660,37109302,37109303,37110334,37110537,37110538,37116448,37116449,37116586,37116588,37116589,37116591,37208025,37208026,37208047,37208048,37395573,37395648,37395649,37395650,37395651,40486896,40489795,40490929,40492416,40649300,40650072,40650479,42536528,42536743,42536892,42536893,42536894,42536895,42536896,42537754,42537755,42538835,42539581,42709762,42709763,42709931,45769098,45770892))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (24296,25486,25757,26052,26361,26638,27235,28083,30346,31509,72566,74582,75488,76349,76914,76924,78093,79749,79758,80045,80340,81237,81239,132258,132565,132832,133147,133420,133424,133969,134290,134295,134579,135476,135489,135491,135750,136639,136915,136916,136917,137219,137800,137809,138074,138351,139750,139753,140046,140950,192255,192836,192847,193138,193418,193422,193719,193971,194589,195197,195480,195482,195483,196044,196047,196048,196049,196359,196360,197225,197500,197507,197799,197804,197806,197807,197808,198091,198104,198985,198988,199754,200051,200052,200054,200962,200963,201238,201517,201518,201519,201801,252840,254282,255192,256633,257503,258369,259748,259755,260336,261514,261808,316644,317801,372567,373151,374874,375490,376647,376918,377811,378696,379756,380055,380661,432254,432256,432257,432260,432262,432263,432264,432559,432833,432837,432838,432843,432844,432845,432848,433143,433148,433149,433423,433704,433709,433716,433973,433975,433976,434285,434289,434291,434292,434293,434577,434587,434588,434880,435190,435474,435478,435484,435487,435493,435751,435752,435755,436042,436050,436054,436344,436348,436352,436353,436357,436358,436635,436640,436643,436913,436919,436922,436923,436926,437220,437224,437498,437501,437798,437805,438080,438086,438089,438094,438360,438367,438368,438370,438692,438693,438694,438699,438977,438979,438982,439392,439404,439738,439739,439745,439746,440036,440047,440335,440339,440344,440345,440649,440658,440956,441223,441224,441225,441230,441233,441510,441513,441515,441520,441800,441802,441805,441806,441809,442122,442123,442126,442127,442131,442132,442134,442139,444203,600832,601104,601105,601106,601110,601112,601113,601124,601125,601126,601127,601128,601129,601130,601131,601132,601133,601134,601135,601136,601137,601138,601139,601140,601144,601145,601146,601147,601148,601149,601150,601152,601154,601155,601156,602102,602103,602193,603310,603311,605509,608064,608889,608892,608923,608924,609043,609044,609046,609047,609064,609065,609067,609180,609196,609197,609202,609203,609239,609305,609306,619299,619300,619301,619369,619378,619379,619380,619381,619382,619383,760999,761000,761001,762368,764936,764981,765123,3662037,4001318,4001319,4001320,4001321,4002340,4002342,4002345,4002348,4002352,4002353,4003028,4003173,4003175,4003179,4003674,4003675,4003683,4003694,4033890,4094409,4149322,4155169,4155170,4155171,4155172,4156114,4157320,4157454,4157456,4158563,4162115,4162117,4162119,4162120,4162122,4162253,4162859,4162860,4162861,4162862,4179720,4187850,4187851,4188545,4216273,4220184,4221964,4244491,4246013,4246014,4246015,4246016,4246017,4246018,4246019,4246020,4246021,4246022,4246023,4246024,4246025,4246026,4246027,4246028,4246029,4246030,4246031,4246032,4246033,4246034,4246035,4246036,4246037,4246039,4246040,4246042,4246120,4246121,4246122,4246124,4246125,4246126,4246128,4246130,4246131,4246133,4246134,4246135,4246136,4246137,4246138,4246139,4246140,4246141,4246142,4246143,4246144,4246146,4246147,4246148,4246224,4246225,4246226,4246227,4246228,4246229,4246230,4246231,4246232,4246233,4246234,4246235,4246236,4246237,4246238,4246239,4246240,4246241,4246243,4246245,4246246,4246248,4246249,4246793,4246794,4246795,4246796,4246797,4246798,4246799,4246800,4246801,4246802,4246803,4246804,4246805,4246807,4246808,4246809,4246810,4246922,4246923,4246924,4247227,4247228,4247229,4247230,4247232,4247233,4247236,4247237,4247238,4247239,4247241,4247242,4247331,4247332,4247335,4247336,4247337,4247338,4247339,4247340,4247341,4247345,4247346,4247347,4247348,4247349,4247350,4247351,4247352,4247353,4247354,4247355,4247356,4247357,4247358,4247360,4247361,4247716,4247719,4247720,4247723,4247724,4247725,4247726,4247727,4247821,4247822,4247823,4247824,4247825,4247826,4247828,4247829,4247830,4247831,4247832,4247834,4247835,4247836,4247837,4247838,4247839,4247840,4247841,4247842,4247843,4247844,4247846,4247847,4247849,4247850,4247851,4281019,4283748,4289388,4289392,4289681,4297711,4307721,4311474,4311475,4311476,4311477,4311478,4311479,4311480,4311481,4311483,4311485,4311486,4311487,4311488,4311489,4311490,4311491,4311492,4311493,4311496,4311497,4311498,4311499,4311500,4311501,4311502,4311612,4311614,4311617,4311618,4311619,4311620,4311621,4311625,4311626,4311627,4311628,4312004,4312032,4312033,4312565,4312566,4312567,4312675,4312676,4312677,4312680,4312681,4312682,4312683,4312684,4312685,4312686,4312687,4312688,4312689,4312690,4312691,4312692,4312693,4312694,4312695,4312698,4313056,35617803,35617871,35617882,35617893,35619970,35619980,35619986,35619990,36684472,36684473,36684817,36684818,36684819,36684820,36684821,36712933,36712934,36715789,36715801,36715852,36715857,36715858,36715859,36715860,36715865,36715888,36715891,36715913,36715914,36716492,36716493,36716499,36716500,36716501,36716505,36717179,37016123,37016124,37016439,37018660,37109302,37109303,37110334,37110537,37110538,37116448,37116449,37116586,37116588,37116589,37116591,37208025,37208026,37208047,37208048,37395573,37395648,37395649,37395650,37395651,40486896,40489795,40490929,40492416,40649300,40650072,40650479,42536528,42536743,42536892,42536893,42536894,42536895,42536896,42537754,42537755,42538835,42539581,42709762,42709763,42709931,45769098,45770892))

) I
) C;

UPDATE STATISTICS #Codesets;


SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, visit_occurrence_id
INTO #qualified_events
FROM 
(
  select pe.event_id, pe.person_id, pe.start_date, pe.end_date, pe.op_start_date, pe.op_end_date, row_number() over (partition by pe.person_id order by pe.start_date ASC) as ordinal, cast(pe.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM (-- Begin Primary Events
select P.ordinal as event_id, P.person_id, P.start_date, P.end_date, op_start_date, op_end_date, cast(P.visit_occurrence_id as bigint) as visit_occurrence_id
FROM
(
  select E.person_id, E.start_date, E.end_date,
         row_number() OVER (PARTITION BY E.person_id ORDER BY E.sort_date ASC, E.event_id) ordinal,
         OP.observation_period_start_date as op_start_date, OP.observation_period_end_date as op_end_date, cast(E.visit_occurrence_id as bigint) as visit_occurrence_id
  FROM 
  (
  -- Begin Condition Occurrence Criteria
SELECT C.person_id, C.condition_occurrence_id as event_id, C.start_date, C.end_date,
  C.visit_occurrence_id, C.start_date as sort_date
FROM 
(
  SELECT co.person_id,co.condition_occurrence_id,co.condition_concept_id,co.visit_occurrence_id,co.condition_start_date as start_date, COALESCE(co.condition_end_date, DATEADD(day,1,co.condition_start_date)) as end_date 
  FROM @cdm_database_schema.CONDITION_OCCURRENCE co
  JOIN #Codesets cs on (co.condition_concept_id = cs.concept_id and cs.codeset_id = 0)
) C


-- End Condition Occurrence Criteria

  ) E
	JOIN @cdm_database_schema.observation_period OP on E.person_id = OP.person_id and E.start_date >=  OP.observation_period_start_date and E.start_date <= op.observation_period_end_date
  WHERE DATEADD(day,0,OP.OBSERVATION_PERIOD_START_DATE) <= E.START_DATE AND DATEADD(day,0,E.START_DATE) <= OP.OBSERVATION_PERIOD_END_DATE
) P
WHERE P.ordinal = 1
-- End Primary Events
) pe
  
) QE

;

--- Inclusion Rule Inserts

create table #inclusion_events (inclusion_rule_id bigint,
	person_id bigint,
	event_id bigint
);

select event_id, person_id, start_date, end_date, op_start_date, op_end_date
into #included_events
FROM (
  SELECT event_id, person_id, start_date, end_date, op_start_date, op_end_date, row_number() over (partition by person_id order by start_date ASC) as ordinal
  from
  (
    select Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date, SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) as inclusion_rule_mask
    from #qualified_events Q
    LEFT JOIN #inclusion_events I on I.person_id = Q.person_id and I.event_id = Q.event_id
    GROUP BY Q.event_id, Q.person_id, Q.start_date, Q.end_date, Q.op_start_date, Q.op_end_date
  ) MG -- matching groups
{0 != 0}?{
  -- the matching group with all bits set ( POWER(2,# of inclusion rules) - 1 = inclusion_rule_mask
  WHERE (MG.inclusion_rule_mask = POWER(cast(2 as bigint),0)-1)
}
) Results
WHERE Results.ordinal = 1
;



-- generate cohort periods into #final_cohort
select person_id, start_date, end_date
INTO #cohort_rows
from ( -- first_ends
	select F.person_id, F.start_date, F.end_date
	FROM (
	  select I.event_id, I.person_id, I.start_date, CE.end_date, row_number() over (partition by I.person_id, I.event_id order by CE.end_date) as ordinal
	  from #included_events I
	  join ( -- cohort_ends
-- cohort exit dates
-- By default, cohort exit at the event's op end date
select event_id, person_id, op_end_date as end_date from #included_events
    ) CE on I.event_id = CE.event_id and I.person_id = CE.person_id and CE.end_date >= I.start_date
	) F
	WHERE F.ordinal = 1
) FE;


select person_id, min(start_date) as start_date, DATEADD(day,-1 * 0, max(end_date)) as end_date
into #final_cohort
from (
  select person_id, start_date, end_date, sum(is_start) over (partition by person_id order by start_date, is_start desc rows unbounded preceding) group_idx
  from (
    select person_id, start_date, end_date, 
      case when max(end_date) over (partition by person_id order by start_date rows between unbounded preceding and 1 preceding) >= start_date then 0 else 1 end is_start
    from (
      select person_id, start_date, DATEADD(day,0,end_date) as end_date
      from #cohort_rows
    ) CR
  ) ST
) GR
group by person_id, group_idx;

DELETE FROM @target_database_schema.@target_cohort_table where cohort_definition_id = @target_cohort_id;
INSERT INTO @target_database_schema.@target_cohort_table (cohort_definition_id, subject_id, cohort_start_date, cohort_end_date)
select @target_cohort_id as cohort_definition_id, person_id, start_date, end_date 
FROM #final_cohort CO
;

{0 != 0}?{
-- BEGIN: Censored Stats

delete from @results_database_schema.cohort_censor_stats where cohort_definition_id = @target_cohort_id;

-- END: Censored Stats
}
{0 != 0 & 0 != 0}?{

CREATE TABLE #inclusion_rules (rule_sequence int);

-- Find the event that is the 'best match' per person.  
-- the 'best match' is defined as the event that satisfies the most inclusion rules.
-- ties are solved by choosing the event that matches the earliest inclusion rule, and then earliest.

select q.person_id, q.event_id
into #best_events
from #qualified_events Q
join (
	SELECT R.person_id, R.event_id, ROW_NUMBER() OVER (PARTITION BY R.person_id ORDER BY R.rule_count DESC,R.min_rule_id ASC, R.start_date ASC) AS rank_value
	FROM (
		SELECT Q.person_id, Q.event_id, COALESCE(COUNT(DISTINCT I.inclusion_rule_id), 0) AS rule_count, COALESCE(MIN(I.inclusion_rule_id), 0) AS min_rule_id, Q.start_date
		FROM #qualified_events Q
		LEFT JOIN #inclusion_events I ON q.person_id = i.person_id AND q.event_id = i.event_id
		GROUP BY Q.person_id, Q.event_id, Q.start_date
	) R
) ranked on Q.person_id = ranked.person_id and Q.event_id = ranked.event_id
WHERE ranked.rank_value = 1
;

-- modes of generation: (the same tables store the results for the different modes, identified by the mode_id column)
-- 0: all events
-- 1: best event


-- BEGIN: Inclusion Impact Analysis - event
-- calculte matching group counts
delete from @results_database_schema.cohort_inclusion_result where cohort_definition_id = @target_cohort_id and mode_id = 0;
insert into @results_database_schema.cohort_inclusion_result (cohort_definition_id, inclusion_rule_mask, person_count, mode_id)
select @target_cohort_id as cohort_definition_id, inclusion_rule_mask, count_big(*) as person_count, 0 as mode_id
from
(
  select Q.person_id, Q.event_id, CAST(SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) AS bigint) as inclusion_rule_mask
  from #qualified_events Q
  LEFT JOIN #inclusion_events I on q.person_id = i.person_id and q.event_id = i.event_id
  GROUP BY Q.person_id, Q.event_id
) MG -- matching groups
group by inclusion_rule_mask
;

-- calculate gain counts 
delete from @results_database_schema.cohort_inclusion_stats where cohort_definition_id = @target_cohort_id and mode_id = 0;
insert into @results_database_schema.cohort_inclusion_stats (cohort_definition_id, rule_sequence, person_count, gain_count, person_total, mode_id)
select @target_cohort_id as cohort_definition_id, ir.rule_sequence, coalesce(T.person_count, 0) as person_count, coalesce(SR.person_count, 0) gain_count, EventTotal.total, 0 as mode_id
from #inclusion_rules ir
left join
(
  select i.inclusion_rule_id, count_big(i.event_id) as person_count
  from #qualified_events Q
  JOIN #inclusion_events i on Q.person_id = I.person_id and Q.event_id = i.event_id
  group by i.inclusion_rule_id
) T on ir.rule_sequence = T.inclusion_rule_id
CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
CROSS JOIN (select count_big(event_id) as total from #qualified_events) EventTotal
LEFT JOIN @results_database_schema.cohort_inclusion_result SR on SR.mode_id = 0 AND SR.cohort_definition_id = @target_cohort_id AND (POWER(cast(2 as bigint),RuleTotal.total_rules) - POWER(cast(2 as bigint),ir.rule_sequence) - 1) = SR.inclusion_rule_mask -- POWER(2,rule count) - POWER(2,rule sequence) - 1 is the mask for 'all except this rule'
;

-- calculate totals
delete from @results_database_schema.cohort_summary_stats where cohort_definition_id = @target_cohort_id and mode_id = 0;
insert into @results_database_schema.cohort_summary_stats (cohort_definition_id, base_count, final_count, mode_id)
select @target_cohort_id as cohort_definition_id, PC.total as person_count, coalesce(FC.total, 0) as final_count, 0 as mode_id
FROM
(select count_big(event_id) as total from #qualified_events) PC,
(select sum(sr.person_count) as total
  from @results_database_schema.cohort_inclusion_result sr
  CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
  where sr.mode_id = 0 and sr.cohort_definition_id = @target_cohort_id and sr.inclusion_rule_mask = POWER(cast(2 as bigint),RuleTotal.total_rules)-1
) FC
;

-- END: Inclusion Impact Analysis - event

-- BEGIN: Inclusion Impact Analysis - person
-- calculte matching group counts
delete from @results_database_schema.cohort_inclusion_result where cohort_definition_id = @target_cohort_id and mode_id = 1;
insert into @results_database_schema.cohort_inclusion_result (cohort_definition_id, inclusion_rule_mask, person_count, mode_id)
select @target_cohort_id as cohort_definition_id, inclusion_rule_mask, count_big(*) as person_count, 1 as mode_id
from
(
  select Q.person_id, Q.event_id, CAST(SUM(coalesce(POWER(cast(2 as bigint), I.inclusion_rule_id), 0)) AS bigint) as inclusion_rule_mask
  from #best_events Q
  LEFT JOIN #inclusion_events I on q.person_id = i.person_id and q.event_id = i.event_id
  GROUP BY Q.person_id, Q.event_id
) MG -- matching groups
group by inclusion_rule_mask
;

-- calculate gain counts 
delete from @results_database_schema.cohort_inclusion_stats where cohort_definition_id = @target_cohort_id and mode_id = 1;
insert into @results_database_schema.cohort_inclusion_stats (cohort_definition_id, rule_sequence, person_count, gain_count, person_total, mode_id)
select @target_cohort_id as cohort_definition_id, ir.rule_sequence, coalesce(T.person_count, 0) as person_count, coalesce(SR.person_count, 0) gain_count, EventTotal.total, 1 as mode_id
from #inclusion_rules ir
left join
(
  select i.inclusion_rule_id, count_big(i.event_id) as person_count
  from #best_events Q
  JOIN #inclusion_events i on Q.person_id = I.person_id and Q.event_id = i.event_id
  group by i.inclusion_rule_id
) T on ir.rule_sequence = T.inclusion_rule_id
CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
CROSS JOIN (select count_big(event_id) as total from #best_events) EventTotal
LEFT JOIN @results_database_schema.cohort_inclusion_result SR on SR.mode_id = 1 AND SR.cohort_definition_id = @target_cohort_id AND (POWER(cast(2 as bigint),RuleTotal.total_rules) - POWER(cast(2 as bigint),ir.rule_sequence) - 1) = SR.inclusion_rule_mask -- POWER(2,rule count) - POWER(2,rule sequence) - 1 is the mask for 'all except this rule'
;

-- calculate totals
delete from @results_database_schema.cohort_summary_stats where cohort_definition_id = @target_cohort_id and mode_id = 1;
insert into @results_database_schema.cohort_summary_stats (cohort_definition_id, base_count, final_count, mode_id)
select @target_cohort_id as cohort_definition_id, PC.total as person_count, coalesce(FC.total, 0) as final_count, 1 as mode_id
FROM
(select count_big(event_id) as total from #best_events) PC,
(select sum(sr.person_count) as total
  from @results_database_schema.cohort_inclusion_result sr
  CROSS JOIN (select count(*) as total_rules from #inclusion_rules) RuleTotal
  where sr.mode_id = 1 and sr.cohort_definition_id = @target_cohort_id and sr.inclusion_rule_mask = POWER(cast(2 as bigint),RuleTotal.total_rules)-1
) FC
;

-- END: Inclusion Impact Analysis - person

TRUNCATE TABLE #best_events;
DROP TABLE #best_events;

TRUNCATE TABLE #inclusion_rules;
DROP TABLE #inclusion_rules;
}



TRUNCATE TABLE #cohort_rows;
DROP TABLE #cohort_rows;

TRUNCATE TABLE #final_cohort;
DROP TABLE #final_cohort;

TRUNCATE TABLE #inclusion_events;
DROP TABLE #inclusion_events;

TRUNCATE TABLE #qualified_events;
DROP TABLE #qualified_events;

TRUNCATE TABLE #included_events;
DROP TABLE #included_events;

TRUNCATE TABLE #Codesets;
DROP TABLE #Codesets;
