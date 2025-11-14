CREATE TABLE #Codesets (
  codeset_id int NOT NULL,
  concept_id bigint NOT NULL
)
;

INSERT INTO #Codesets (codeset_id, concept_id)
SELECT 0 as codeset_id, c.concept_id FROM (select distinct I.concept_id FROM
( 
  select concept_id from @vocabulary_database_schema.CONCEPT where (concept_id in (72266,78097,78987,136354,140960,192568,193144,194585,196053,196925,198371,198700,199752,200348,200959,201240,253717,254591,318096,320342,373425,378087,434298,434875,439751,440341,442173,442174,442177,442178,442181,442182,442183,442188,442252,601141,601143,602316,602331,602332,602333,602334,602668,603292,605437,607797,608735,608866,608979,608980,608981,759974,760916,3654229,4027231,4055132,4091762,4091766,4096952,4097426,4147162,4158910,4162133,4220182,4246251,4246253,4246347,4246349,4246350,4246352,4246354,4246355,4246356,4246357,4246358,4246367,4246368,4246369,4246450,4246451,4246452,4246453,4246454,4246455,4246457,4246458,4247943,4247944,4247945,4247946,4247947,4247948,4247949,4247960,4247961,4247962,4247963,4247964,4247965,4247966,4247967,4248055,4248056,4248057,4248058,4248059,4248060,4248061,4248062,4248063,4248064,4248065,4248066,4248067,4248068,4248069,4248070,4248071,4248073,4248074,4248076,4248077,4248078,4248079,4248081,4248082,4248182,4248183,4248184,4248185,4248186,4248187,4248189,4248190,4248191,4248192,4248193,4248194,4248195,4248197,4248198,4248199,4248200,4266182,4281024,4281027,4281030,4283739,4289680,4302810,4308759,4311208,4311209,4311210,4311211,4311212,4311320,4311321,4311322,4311323,4311324,4311326,4311327,4311328,4311329,4311331,4311332,4311333,4311334,4311335,4311336,4311337,4311339,4311340,4311341,4311342,4311344,4311345,4311346,4311347,4311348,4311349,4311472,4311473,4311630,4311631,4311632,4311633,4311634,4311635,4311636,4311637,4311638,4311746,4311747,4311756,4311757,4311758,4311759,4311760,4311762,4311763,4311764,4311765,4311766,4311767,4311768,4311875,4311876,4311877,4311878,4311879,4311880,4311881,4311895,4311896,4311897,4312012,4312013,4312014,4312015,4312016,4312017,4312018,4312019,4312020,4312022,4312023,4312024,4312026,4312027,4312028,4312037,4312038,4312039,4312040,4312041,4312148,4312149,4312150,4312151,4312152,4312165,4312166,4312167,4312275,4312276,4312277,4312278,4312279,4312280,4312281,4312282,4312283,4312284,4312285,4312286,4312287,4312288,4312289,4312290,4312291,4312293,4312295,4312296,4312297,4312299,4312300,4312301,4312302,4312303,4312423,4312425,4312426,4312427,4312429,4312430,4312540,4312542,4312543,4312544,4312545,4312546,4312547,4312548,4312549,4312550,4312551,4312552,4312553,4312554,4312555,4312556,4312557,4312558,4312559,4312560,4312561,4312562,4312563,4312564,4312699,4312700,4312701,4312702,4312703,4312705,4312802,4312803,4312804,4312805,4312820,4312821,4312823,4312824,4312825,4312934,4312935,4312936,4312937,4312938,4312939,4312940,4312941,4312943,4312944,4312945,4312946,4312947,4312948,4312949,4312950,4312951,4312952,4312954,4312955,4312956,4312957,4313077,4313078,4313079,4313080,4313081,4313082,4313083,4313085,4313086,4313087,4313088,4313089,4313090,4313091,4313092,4313206,4313207,4313208,4313209,4313210,4313211,4313212,4313214,4313215,4313216,4313217,4313218,4313220,4313221,4313222,4313223,4313224,4313225,4313226,4313789,4313791,4313792,4313793,4313794,4313795,4313796,4313797,4313798,4313799,4313801,4313802,4313803,4313911,4313912,4313913,4313914,4313915,4313916,4313917,4313918,4313919,4313920,4313921,4313922,4313924,4313925,4313926,4313927,4313928,4313930,4313931,4313932,4313933,4313934,4313935,4313936,4313937,4313939,4314046,4314047,4314048,4314049,4314050,4314052,4314053,4314054,4314055,4314056,4314057,4314058,4314059,4314061,4314062,4314063,4314065,4314066,4314067,4314068,4314069,4314070,4314071,4314072,4314073,4314189,4314190,4314191,4314192,4314193,4314194,4314195,4314196,4314197,4314198,4314199,4314336,4314337,4314338,4314339,4314340,4314341,4314342,4314343,4314344,4314345,4314346,4314347,4314348,4314349,4314350,4314351,4314352,4314354,4314355,4314356,4314357,4314358,4314359,4314360,4314361,4314362,4314478,4314479,4314480,4314481,4314482,4314483,4314484,4314485,4314486,4314487,4314488,4314489,4314490,4314491,4314492,4314493,4314494,4314495,4314496,4314497,4314498,4314499,4314500,4315537,4315538,4315539,4315540,4315541,4315542,4315543,4315544,4315545,4315546,4315547,4315548,4315549,4315550,4315552,4315553,4315657,4315658,4315659,4315661,4315662,4315663,4315664,4315666,4315667,4315668,4315670,4315671,4315672,4315673,4315674,4315675,4315677,4315678,4315679,4315680,4315681,4315683,4315684,4315685,4315686,4315793,4315794,4315795,4315796,4315797,4315798,4315799,4315800,4315801,4315802,4315804,4315805,4315806,4315807,4315808,4315809,4315810,4315811,4315812,4315813,4315814,4315815,35610147,35610148,35610149,35610150,35610151,35610152,35610154,35610155,35610156,35610157,35610158,35610159,35610160,35610162,36683301,36712822,36713026,36717298,37310458,42709758,42709759,42709760,42709761,44806773,46270513,46271211,46273652))
UNION  select c.concept_id
  from @vocabulary_database_schema.CONCEPT c
  join @vocabulary_database_schema.CONCEPT_ANCESTOR ca on c.concept_id = ca.descendant_concept_id
  WHERE c.invalid_reason is null
  and (ca.ancestor_concept_id in (72266,78097,78987,136354,140960,192568,193144,194585,196053,196925,198371,198700,199752,200348,200959,201240,253717,254591,318096,320342,373425,378087,434298,434875,439751,440341,442173,442174,442177,442178,442181,442182,442183,442188,442252,601141,601143,602316,602331,602332,602333,602334,602668,603292,605437,607797,608735,608866,608979,608980,608981,759974,760916,3654229,4027231,4055132,4091762,4091766,4096952,4097426,4147162,4158910,4162133,4220182,4246251,4246253,4246347,4246349,4246350,4246352,4246354,4246355,4246356,4246357,4246358,4246367,4246368,4246369,4246450,4246451,4246452,4246453,4246454,4246455,4246457,4246458,4247943,4247944,4247945,4247946,4247947,4247948,4247949,4247960,4247961,4247962,4247963,4247964,4247965,4247966,4247967,4248055,4248056,4248057,4248058,4248059,4248060,4248061,4248062,4248063,4248064,4248065,4248066,4248067,4248068,4248069,4248070,4248071,4248073,4248074,4248076,4248077,4248078,4248079,4248081,4248082,4248182,4248183,4248184,4248185,4248186,4248187,4248189,4248190,4248191,4248192,4248193,4248194,4248195,4248197,4248198,4248199,4248200,4266182,4281024,4281027,4281030,4283739,4289680,4302810,4308759,4311208,4311209,4311210,4311211,4311212,4311320,4311321,4311322,4311323,4311324,4311326,4311327,4311328,4311329,4311331,4311332,4311333,4311334,4311335,4311336,4311337,4311339,4311340,4311341,4311342,4311344,4311345,4311346,4311347,4311348,4311349,4311472,4311473,4311630,4311631,4311632,4311633,4311634,4311635,4311636,4311637,4311638,4311746,4311747,4311756,4311757,4311758,4311759,4311760,4311762,4311763,4311764,4311765,4311766,4311767,4311768,4311875,4311876,4311877,4311878,4311879,4311880,4311881,4311895,4311896,4311897,4312012,4312013,4312014,4312015,4312016,4312017,4312018,4312019,4312020,4312022,4312023,4312024,4312026,4312027,4312028,4312037,4312038,4312039,4312040,4312041,4312148,4312149,4312150,4312151,4312152,4312165,4312166,4312167,4312275,4312276,4312277,4312278,4312279,4312280,4312281,4312282,4312283,4312284,4312285,4312286,4312287,4312288,4312289,4312290,4312291,4312293,4312295,4312296,4312297,4312299,4312300,4312301,4312302,4312303,4312423,4312425,4312426,4312427,4312429,4312430,4312540,4312542,4312543,4312544,4312545,4312546,4312547,4312548,4312549,4312550,4312551,4312552,4312553,4312554,4312555,4312556,4312557,4312558,4312559,4312560,4312561,4312562,4312563,4312564,4312699,4312700,4312701,4312702,4312703,4312705,4312802,4312803,4312804,4312805,4312820,4312821,4312823,4312824,4312825,4312934,4312935,4312936,4312937,4312938,4312939,4312940,4312941,4312943,4312944,4312945,4312946,4312947,4312948,4312949,4312950,4312951,4312952,4312954,4312955,4312956,4312957,4313077,4313078,4313079,4313080,4313081,4313082,4313083,4313085,4313086,4313087,4313088,4313089,4313090,4313091,4313092,4313206,4313207,4313208,4313209,4313210,4313211,4313212,4313214,4313215,4313216,4313217,4313218,4313220,4313221,4313222,4313223,4313224,4313225,4313226,4313789,4313791,4313792,4313793,4313794,4313795,4313796,4313797,4313798,4313799,4313801,4313802,4313803,4313911,4313912,4313913,4313914,4313915,4313916,4313917,4313918,4313919,4313920,4313921,4313922,4313924,4313925,4313926,4313927,4313928,4313930,4313931,4313932,4313933,4313934,4313935,4313936,4313937,4313939,4314046,4314047,4314048,4314049,4314050,4314052,4314053,4314054,4314055,4314056,4314057,4314058,4314059,4314061,4314062,4314063,4314065,4314066,4314067,4314068,4314069,4314070,4314071,4314072,4314073,4314189,4314190,4314191,4314192,4314193,4314194,4314195,4314196,4314197,4314198,4314199,4314336,4314337,4314338,4314339,4314340,4314341,4314342,4314343,4314344,4314345,4314346,4314347,4314348,4314349,4314350,4314351,4314352,4314354,4314355,4314356,4314357,4314358,4314359,4314360,4314361,4314362,4314478,4314479,4314480,4314481,4314482,4314483,4314484,4314485,4314486,4314487,4314488,4314489,4314490,4314491,4314492,4314493,4314494,4314495,4314496,4314497,4314498,4314499,4314500,4315537,4315538,4315539,4315540,4315541,4315542,4315543,4315544,4315545,4315546,4315547,4315548,4315549,4315550,4315552,4315553,4315657,4315658,4315659,4315661,4315662,4315663,4315664,4315666,4315667,4315668,4315670,4315671,4315672,4315673,4315674,4315675,4315677,4315678,4315679,4315680,4315681,4315683,4315684,4315685,4315686,4315793,4315794,4315795,4315796,4315797,4315798,4315799,4315800,4315801,4315802,4315804,4315805,4315806,4315807,4315808,4315809,4315810,4315811,4315812,4315813,4315814,4315815,35610147,35610148,35610149,35610150,35610151,35610152,35610154,35610155,35610156,35610157,35610158,35610159,35610160,35610162,36683301,36712822,36713026,36717298,37310458,42709758,42709759,42709760,42709761,44806773,46270513,46271211,46273652))

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
