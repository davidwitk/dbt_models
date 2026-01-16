




with a as (

    select 
      
      1 as id_dbtutils_test_equal_rowcount,
      count(*) as count_a 
    from "prod"."raw_mubi"."top_movies__details"
    group by id_dbtutils_test_equal_rowcount


),
b as (

    select 
      
      1 as id_dbtutils_test_equal_rowcount,
      count(*) as count_b 
    from "prod"."raw_mubi"."top_movies"
    group by id_dbtutils_test_equal_rowcount

),
final as (

    select
    
        a.id_dbtutils_test_equal_rowcount as id_dbtutils_test_equal_rowcount_a,
          b.id_dbtutils_test_equal_rowcount as id_dbtutils_test_equal_rowcount_b,
        

        count_a,
        count_b,
        abs(count_a - count_b) as diff_count

    from a
    full join b
    on
    a.id_dbtutils_test_equal_rowcount = b.id_dbtutils_test_equal_rowcount
    


)

select * from final

