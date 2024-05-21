BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.DYN.OPPORTUNITY;
        
        INSERT INTO RAW.DYN.OPPORTUNITY (
            "@ODATA.ETAG",
            PRIORITYCODE,
            SALESSTAGE,
            STEPNAME,
            FILEDEBRIEF,
            ACTUALVALUE_BASE,
            ESTIMATEDCLOSEDATE,
            CONFIRMINTEREST,
            CAPTUREPROPOSALFEEDBACK,
            EXCHANGERATE,
            OPPORTUNITYID,
            _PARENTCONTACTID_VALUE,
            IDENTIFYCOMPETITORS,
            _PARENTACCOUNTID_VALUE,
            NAME,
            DECISIONMAKER,
            NEW_ESTWEIGHTEDREVENUE_BASE,
            TOTALLINEITEMAMOUNT,
            ISREVENUESYSTEMCALCULATED,
            MODIFIEDON,
            _OWNINGUSER_VALUE,
            NEW_OPPORTUNITYTYPE,
            TOTALAMOUNT,
            PRESENTPROPOSAL,
            NEW_EXPECTEDGROSSPROFIT,
            PROPOSEDSOLUTION,
            TOTALDISCOUNTAMOUNT,
            _OWNERID_VALUE,
            SENDTHANKYOUNOTE,
            IDENTIFYCUSTOMERCONTACTS,
            ACTUALVALUE,
            EVALUATEFIT,
            TOTALAMOUNTLESSFREIGHT,
            TOTALDISCOUNTAMOUNT_BASE,
            TOTALLINEITEMDISCOUNTAMOUNT,
            TOTALAMOUNTLESSFREIGHT_BASE,
            MSDYN_GDPROPTOUT,
            STATUSCODE,
            CREATEDON,
            VERSIONNUMBER,
            MSDYN_ORDERTYPE,
            CUSTOMERNEED,
            TOTALTAX_BASE,
            TOTALLINEITEMAMOUNT_BASE,
            CR3D8_LANESOPTION,
            TOTALAMOUNT_BASE,
            COMPLETEINTERNALREVIEW,
            PURCHASEPROCESS,
            DESCRIPTION,
            ACTUALCLOSEDATE,
            RESOLVEFEEDBACK,
            TOTALTAX,
            NEW_OPPORTUNITYSOURCE,
            _TRANSACTIONCURRENCYID_VALUE,
            ESTIMATEDVALUE,
            ESTIMATEDVALUE_BASE,
            MSDYN_FORECASTCATEGORY,
            _MODIFIEDBY_VALUE,
            PRESENTFINALPROPOSAL,
            _CREATEDBY_VALUE,
            TIMEZONERULEVERSIONNUMBER,
            NEW_ESTWEIGHTEDREVENUE,
            CURRENTSITUATION,
            PRICINGERRORCODE,
            SALESSTAGECODE,
            TOTALLINEITEMDISCOUNTAMOUNT_BASE,
            OPPORTUNITYRATINGCODE,
            IDENTIFYPURSUITTEAM,
            CLOSEPROBABILITY,
            PARTICIPATESINWORKFLOW,
            STATECODE,
            _OWNINGBUSINESSUNIT_VALUE,
            PURSUITDECISION,
            DEVELOPPROPOSAL,
            _CUSTOMERID_VALUE,
            COMPLETEFINALPROPOSAL,
            MSDYN_OPPORTUNITYSCORE,
            NEW_PROJECTID,
            MSDYN_SCOREHISTORY,
            CR3D8_CONTRACTLENGTH,
            _MSDYN_PREDICTIVESCOREID_VALUE,
            NEW_GPOPPORTUNITYMAX,
            MSDYN_OPPORTUNITYSCORETREND,
            INT_FORECAST_BASE,
            _MSDYN_SEGMENTID_VALUE,
            NEW_EXPECTEDMARGIN,
            BUDGETSTATUS,
            FINALDECISIONDATE,
            _SLAINVOKEDID_VALUE,
            MSDYN_OPPORTUNITYGRADE,
            QUOTECOMMENTS,
            _MSA_PARTNERID_VALUE,
            INT_FORECAST,
            TIMELINE,
            QUALIFICATIONCOMMENTS,
            NEW_REVENUEOPPORTUNITYMAX_BASE,
            _MSDYN_WORKORDERTYPE_VALUE,
            _CAMPAIGNID_VALUE,
            STAGEID,
            LASTONHOLDTIME,
            NEED,
            _MODIFIEDONBEHALFBY_VALUE,
            STEPID,
            FREIGHTAMOUNT_BASE,
            PROCESSID,
            ONHOLDTIME,
            DISCOUNTAMOUNT_BASE,
            SCHEDULEFOLLOWUP_QUALIFY,
            IMPORTSEQUENCENUMBER,
            _MSA_PARTNEROPPID_VALUE,
            UTCCONVERSIONTIMEZONECODE,
            NEW_PROBABILITY,
            NEW_EXPECTEDLOADSPERMONTH,
            DISCOUNTAMOUNT,
            TRAVERSEDPATH,
            _CREATEDONBEHALFBY_VALUE,
            NEW_ACCOUNTOPPORTUNITYLOADSMAX,
            _ORIGINATINGLEADID_VALUE,
            NEW_EXPECTEDMARGINPERSHIPMENT,
            CUSTOMERPAINPOINTS,
            _MSDYN_ACCOUNTMANAGERID_VALUE,
            EMAILADDRESS,
            BUDGETAMOUNT,
            _OWNINGTEAM_VALUE,
            SCHEDULEPROPOSALMEETING,
            _MSDYN_CONTRACTORGANIZATIONALUNITID_VALUE,
            TIMESPENTBYMEONEMAILANDMEETINGS,
            NEW_THROUGHTHETILL,
            PURCHASETIMEFRAME,
            NEW_GROSSPROFIT_BASE,
            _PRICELEVELID_VALUE,
            OVERRIDDENCREATEDON,
            NEW_GROSSPROFIT,
            INITIALCOMMUNICATION,
            SCHEDULEFOLLOWUP_PROSPECT,
            MSDYN_SCOREREASONS,
            BUDGETAMOUNT_BASE,
            FREIGHTAMOUNT,
            NEW_EXPECTEDMARGINPERSHIPMENT_BASE,
            DISCOUNTPERCENTAGE,
            NEW_REVENUEOPPORTUNITYMAX,
            _SLAID_VALUE,
            NEW_GPOPPORTUNITYMAX_BASE,
            NEW_ESTOPSGOLIVE,
            LOAD_TS
        ) 
            SELECT
                VAR:"@odata.etag"::VARCHAR(16777216),
                VAR:prioritycode::NUMBER,
                VAR:salesstage::NUMBER,
                VAR:stepname::VARCHAR(16777216),
                VAR:filedebrief::BOOLEAN,
                VAR:actualvalue_base::NUMBER,
                VAR:estimatedclosedate::NUMBER,
                VAR:confirminterest::BOOLEAN,
                VAR:captureproposalfeedback::BOOLEAN,
                VAR:exchangerate::NUMBER,
                VAR:opportunityid::VARCHAR(16777216),
                VAR:_parentcontactid_value::VARCHAR(16777216),
                VAR:identifycompetitors::BOOLEAN,
                VAR:_parentaccountid_value::VARCHAR(16777216),
                VAR:name::VARCHAR(16777216),
                VAR:decisionmaker::BOOLEAN,
                VAR:new_estweightedrevenue_base::NUMBER,
                VAR:totallineitemamount::NUMBER,
                VAR:isrevenuesystemcalculated::BOOLEAN,
                VAR:modifiedon::NUMBER,
                VAR:_owninguser_value::VARCHAR(16777216),
                VAR:new_opportunitytype::NUMBER,
                VAR:totalamount::NUMBER,
                VAR:presentproposal::BOOLEAN,
                VAR:new_expectedgrossprofit::NUMBER,
                VAR:proposedsolution::VARCHAR(16777216),
                VAR:totaldiscountamount::NUMBER,
                VAR:_ownerid_value::VARCHAR(16777216),
                VAR:sendthankyounote::BOOLEAN,
                VAR:identifycustomercontacts::BOOLEAN,
                VAR:actualvalue::NUMBER,
                VAR:evaluatefit::BOOLEAN,
                VAR:totalamountlessfreight::NUMBER,
                VAR:totaldiscountamount_base::NUMBER,
                VAR:totallineitemdiscountamount::NUMBER,
                VAR:totalamountlessfreight_base::NUMBER,
                VAR:msdyn_gdproptout::BOOLEAN,
                VAR:statuscode::NUMBER,
                VAR:createdon::NUMBER,
                VAR:versionnumber::NUMBER,
                VAR:msdyn_ordertype::NUMBER,
                VAR:customerneed::VARCHAR(16777216),
                VAR:totaltax_base::NUMBER,
                VAR:totallineitemamount_base::NUMBER,
                VAR:cr3d8_lanesoption::VARCHAR(16777216),
                VAR:totalamount_base::NUMBER,
                VAR:completeinternalreview::BOOLEAN,
                VAR:purchaseprocess::NUMBER,
                VAR:description::VARCHAR(16777216),
                VAR:actualclosedate::NUMBER,
                VAR:resolvefeedback::BOOLEAN,
                VAR:totaltax::NUMBER,
                VAR:new_opportunitysource::NUMBER,
                VAR:_transactioncurrencyid_value::VARCHAR(16777216),
                VAR:estimatedvalue::NUMBER,
                VAR:estimatedvalue_base::NUMBER,
                VAR:msdyn_forecastcategory::NUMBER,
                VAR:_modifiedby_value::VARCHAR(16777216),
                VAR:presentfinalproposal::BOOLEAN,
                VAR:_createdby_value::VARCHAR(16777216),
                VAR:timezoneruleversionnumber::NUMBER,
                VAR:new_estweightedrevenue::NUMBER,
                VAR:currentsituation::VARCHAR(16777216),
                VAR:pricingerrorcode::NUMBER,
                VAR:salesstagecode::NUMBER,
                VAR:totallineitemdiscountamount_base::NUMBER,
                VAR:opportunityratingcode::NUMBER,
                VAR:identifypursuitteam::BOOLEAN,
                VAR:closeprobability::NUMBER,
                VAR:participatesinworkflow::BOOLEAN,
                VAR:statecode::NUMBER,
                VAR:_owningbusinessunit_value::VARCHAR(16777216),
                VAR:pursuitdecision::BOOLEAN,
                VAR:developproposal::BOOLEAN,
                VAR:_customerid_value::VARCHAR(16777216),
                VAR:completefinalproposal::BOOLEAN,
                VAR:msdyn_opportunityscore::VARCHAR(16777216),
                VAR:new_projectid::VARCHAR(16777216),
                VAR:msdyn_scorehistory::VARCHAR(16777216),
                VAR:cr3d8_contractlength::VARCHAR(16777216),
                VAR:_msdyn_predictivescoreid_value::VARCHAR(16777216),
                VAR:new_gpopportunitymax::NUMBER,
                VAR:msdyn_opportunityscoretrend::VARCHAR(16777216),
                VAR:int_forecast_base::VARCHAR(16777216),
                VAR:_msdyn_segmentid_value::VARCHAR(16777216),
                VAR:new_expectedmargin::NUMBER,
                VAR:budgetstatus::VARCHAR(16777216),
                VAR:finaldecisiondate::NUMBER,
                VAR:_slainvokedid_value::VARCHAR(16777216),
                VAR:msdyn_opportunitygrade::VARCHAR(16777216),
                VAR:quotecomments::VARCHAR(16777216),
                VAR:_msa_partnerid_value::VARCHAR(16777216),
                VAR:int_forecast::VARCHAR(16777216),
                VAR:timeline::VARCHAR(16777216),
                VAR:qualificationcomments::VARCHAR(16777216),
                VAR:new_revenueopportunitymax_base::NUMBER,
                VAR:_msdyn_workordertype_value::VARCHAR(16777216),
                VAR:_campaignid_value::VARCHAR(16777216),
                VAR:stageid::VARCHAR(16777216),
                VAR:lastonholdtime::VARCHAR(16777216),
                VAR:need::VARCHAR(16777216),
                VAR:_modifiedonbehalfby_value::VARCHAR(16777216),
                VAR:stepid::VARCHAR(16777216),
                VAR:freightamount_base::VARCHAR(16777216),
                VAR:processid::VARCHAR(16777216),
                VAR:onholdtime::VARCHAR(16777216),
                VAR:discountamount_base::VARCHAR(16777216),
                VAR:schedulefollowup_qualify::VARCHAR(16777216),
                VAR:importsequencenumber::VARCHAR(16777216),
                VAR:_msa_partneroppid_value::VARCHAR(16777216),
                VAR:utcconversiontimezonecode::VARCHAR(16777216),
                VAR:new_probability::VARCHAR(16777216),
                VAR:new_expectedloadspermonth::NUMBER,
                VAR:discountamount::VARCHAR(16777216),
                VAR:traversedpath::VARCHAR(16777216),
                VAR:_createdonbehalfby_value::VARCHAR(16777216),
                VAR:new_accountopportunityloadsmax::NUMBER,
                VAR:_originatingleadid_value::VARCHAR(16777216),
                VAR:new_expectedmarginpershipment::NUMBER,
                VAR:customerpainpoints::VARCHAR(16777216),
                VAR:_msdyn_accountmanagerid_value::VARCHAR(16777216),
                VAR:emailaddress::VARCHAR(16777216),
                VAR:budgetamount::NUMBER,
                VAR:_owningteam_value::VARCHAR(16777216),
                VAR:scheduleproposalmeeting::VARCHAR(16777216),
                VAR:_msdyn_contractorganizationalunitid_value::VARCHAR(16777216),
                VAR:timespentbymeonemailandmeetings::VARCHAR(16777216),
                VAR:new_throughthetill::VARCHAR(16777216),
                VAR:purchasetimeframe::NUMBER,
                VAR:new_grossprofit_base::NUMBER,
                VAR:_pricelevelid_value::VARCHAR(16777216),
                VAR:overriddencreatedon::VARCHAR(16777216),
                VAR:new_grossprofit::NUMBER,
                VAR:initialcommunication::VARCHAR(16777216),
                VAR:schedulefollowup_prospect::VARCHAR(16777216),
                VAR:msdyn_scorereasons::VARCHAR(16777216),
                VAR:budgetamount_base::NUMBER,
                VAR:freightamount::VARCHAR(16777216),
                VAR:new_expectedmarginpershipment_base::NUMBER,
                VAR:discountpercentage::VARCHAR(16777216),
                VAR:new_revenueopportunitymax::NUMBER,
                VAR:_slaid_value::VARCHAR(16777216),
                VAR:new_gpopportunitymax_base::NUMBER,
                VAR:new_estopsgolive::NUMBER,
                SYSDATE()
            FROM 
                RAW.DYN.LOAD_OPPORTUNITY_STREAM;
    COMMIT;
END