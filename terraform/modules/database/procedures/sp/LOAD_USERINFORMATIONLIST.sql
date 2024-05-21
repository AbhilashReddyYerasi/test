BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.SP.USERINFORMATIONLIST; 
        
        INSERT INTO RAW.SP.USERINFORMATIONLIST (
            CONTENTTYPEID,
            NAME,
            COMPLIANCEASSETID,
            ACCOUNT,
            EMAIL,
            OTHERMAIL,
            USEREXPIRATION,
            USERLASTDELETIONTIME,
            MOBILENUMBER,
            ABOUTME,
            SIPADDRESS,
            ISSITEADMIN,
            DELETED,
            HIDDEN,
            PICTURE,
            DEPARTMENT,
            JOBTITLE,
            FIRSTNAME,
            LASTNAME,
            WORKPHONE,
            USERNAME,
            WEBSITE,
            ASKMEABOUT,
            OFFICE,
            PICTURETIMESTAMP,
            PICTUREPLACEHOLDERSTATE,
            PICTUREEXCHANGESYNCSTATE,
            ID,
            CONTENTTYPE,
            MODIFIED,
            CREATED,
            CREATEDBYID,
            MODIFIEDBYID,
            OWSHIDDENVERSION,
            VERSION,
            PATH,
            LOAD_TS
        ) 
            SELECT
                VAR:ContentTypeID::VARCHAR,
                VAR:Name::VARCHAR,
                VAR:ComplianceAssetId::VARCHAR,
                VAR:Account::VARCHAR,
                VAR:EMail::VARCHAR,
                VAR:OtherMail::VARCHAR,
                VAR:UserExpiration::VARCHAR,
                VAR:UserLastDeletionTime::VARCHAR,
                VAR:MobileNumber::VARCHAR,
                VAR:AboutMe::VARCHAR,
                VAR:SIPAddress::VARCHAR,
                VAR:IsSiteAdmin::BOOLEAN,
                VAR:Deleted::BOOLEAN,
                VAR:Hidden::BOOLEAN,
                VAR:Picture::VARCHAR,
                VAR:Department::VARCHAR,
                VAR:JobTitle::VARCHAR,
                VAR:FirstName::VARCHAR,
                VAR:LastName::VARCHAR,
                VAR:WorkPhone::VARCHAR,
                VAR:UserName::VARCHAR,
                VAR:WebSite::VARCHAR,
                VAR:AskMeAbout::VARCHAR,
                VAR:Office::VARCHAR,
                VAR:PictureTimestamp::VARCHAR,
                VAR:PicturePlaceholderState::NUMBER,
                VAR:PictureExchangeSyncState::NUMBER,
                VAR:Id::NUMBER,
                VAR:ContentType::VARCHAR,
                VAR:Modified::TIMESTAMP_NTZ,
                VAR:Created::TIMESTAMP_NTZ,
                VAR:CreatedById::NUMBER,
                VAR:ModifiedById::NUMBER,
                VAR:Owshiddenversion::NUMBER,
                VAR:Version::VARCHAR,
                VAR:Path::VARCHAR,
                SYSDATE()
            FROM 
                RAW.SP.LOAD_USERINFORMATIONLIST_STREAM;
    COMMIT;
END
