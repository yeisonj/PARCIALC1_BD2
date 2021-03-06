PGDMP                         y            Parcial    13.4    13.4 1    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ?           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                        0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16570    Parcial    DATABASE     e   CREATE DATABASE "Parcial" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "Parcial";
                postgres    false            ?            1255    16689    mov_employee()    FUNCTION     S
  CREATE FUNCTION public.mov_employee() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
	enameemployee VARCHAR(50) ;
	eidemployee integer;
	enamebranch VARCHAR(50) ;
	enamedepartment VARCHAR(50) ;
	eposition VARCHAR(50) ;
	eadress VARCHAR(50) ;
	ecity VARCHAR(50) ;
	enamecountry VARCHAR(50) ;
	
BEGIN
		SELECT 
			 employee.idemployee,
			 employee.nameemployee,
			 Branchoffice.namebranch,
			 department.name,
			 position.name,
			 adress.line1,
			 city.namecity,
			 country.namecountry
		 INTO 
			eidemployee,
			enameemployee,
			enamebranch,
			enamedepartment,
			eposition,
			eadress,
			ecity,
			enamecountry
		 FROM 
			employee INNER JOIN 
			branchoffice on Branchoffice.idbranch = employee.idbranch  INNER JOIN 
			department on department.iddepartment = employee.iddepartment INNER JOIN 
			position on position.idposition = employee.idposition INNER JOIN 
			adress on adress.idaddress = employee.idaddress INNER JOIN 
			city on city.idcity = adress.idcity INNER JOIN 
			country on country.idcountry = city.fk_idcountry
		WHERE 
			employee.idemployee = old.idemployee;
			
	IF (TG_OP='DELETE') THEN
		INSERT INTO employeeaudit(
			idemployee, 
			nameemployee, 
			branchoffice, 
			department, 
			supervisor, 
			position, 
			address, 
			city, 
			country)
		VALUES (eidemployee,
				enameemployee, 
				enamebranch, 
				enamedepartment, 
				enameemployee, 
				eposition, 
				eadress, 
				ecity, 
				enamecountry);		
	RETURN NEW;
	END IF;
	
	IF (TG_OP='UPDATE') THEN
		INSERT INTO employeeaudit(
			idemployee, 
			nameemployee, 
			branchoffice, 
			department, 
			supervisor, 
			position, 
			address, 
			city, 
			country)
		VALUES (eidemployee,
				enameemployee, 
				enamebranch, 
				enamedepartment, 
				's', 
				eposition, 
				eadress, 
				ecity, 
				enamecountry);
	RETURN NEW;
	END IF;

	IF (TG_OP='INSERT') THEN
		INSERT INTO employeeaudit
			SELECT
				 employee.idemployee,
				 employee.nameemployee,
				 Branchoffice.namebranch,
				 department.name,
				 employee.nameemployee,
				 position.name,
				 adress.line1,
				 city.namecity,
				 country.namecountry
			 FROM 
				employee INNER JOIN 
				branchoffice on Branchoffice.idbranch = employee.idbranch  INNER JOIN 
				department on department.iddepartment = employee.iddepartment INNER JOIN 
				position on position.idposition = employee.idposition INNER JOIN 
				adress on adress.idaddress = employee.idaddress INNER JOIN 
				city on city.idcity = adress.idcity INNER JOIN 
				country on country.idcountry = city.fk_idcountry
			ORDER BY 
				employee.idemployee DESC
			limit 1	;
	RETURN NEW;
	END IF;
	
END
$$;
 %   DROP FUNCTION public.mov_employee();
       public          postgres    false            ?            1259    16611    adress    TABLE     ?   CREATE TABLE public.adress (
    idaddress integer NOT NULL,
    line1 character varying NOT NULL,
    line2 character varying,
    idcity integer
);
    DROP TABLE public.adress;
       public         heap    postgres    false            ?            1259    16647    Adress_IdAddress_seq    SEQUENCE     ?   ALTER TABLE public.adress ALTER COLUMN idaddress ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Adress_IdAddress_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    205            ?            1259    16587    branchoffice    TABLE     ?   CREATE TABLE public.branchoffice (
    idbranch integer NOT NULL,
    namebranch character varying NOT NULL,
    idadress integer
);
     DROP TABLE public.branchoffice;
       public         heap    postgres    false            ?            1259    16654    BranchOffice_IdBranch_seq    SEQUENCE     ?   ALTER TABLE public.branchoffice ALTER COLUMN idbranch ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."BranchOffice_IdBranch_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    202            ?            1259    16595    city    TABLE     }   CREATE TABLE public.city (
    idcity integer NOT NULL,
    namecity character varying NOT NULL,
    fk_idcountry integer
);
    DROP TABLE public.city;
       public         heap    postgres    false            ?            1259    16645    City_IdCity_seq    SEQUENCE     ?   ALTER TABLE public.city ALTER COLUMN idcity ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."City_IdCity_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    203            ?            1259    16571 
   department    TABLE     k   CREATE TABLE public.department (
    iddepartment integer NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public.department;
       public         heap    postgres    false            ?            1259    16685    Department_IdDepartment_seq    SEQUENCE     ?   ALTER TABLE public.department ALTER COLUMN iddepartment ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Department_IdDepartment_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    200            ?            1259    16619    employee    TABLE     ?   CREATE TABLE public.employee (
    idemployee integer NOT NULL,
    nameemployee character varying NOT NULL,
    iddepartment integer,
    idposition integer,
    idaddress integer,
    idsupervisor integer,
    idbranch integer
);
    DROP TABLE public.employee;
       public         heap    postgres    false            ?            1259    16661    Employee_IdEmployee_seq    SEQUENCE     ?   ALTER TABLE public.employee ALTER COLUMN idemployee ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Employee_IdEmployee_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    206            ?            1259    16579    position    TABLE     i   CREATE TABLE public."position" (
    idposition integer NOT NULL,
    name character varying NOT NULL
);
    DROP TABLE public."position";
       public         heap    postgres    false            ?            1259    16683    Position_IdPosition_seq    SEQUENCE     ?   ALTER TABLE public."position" ALTER COLUMN idposition ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Position_IdPosition_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    201            ?            1259    16603    country    TABLE     l   CREATE TABLE public.country (
    idcountry integer NOT NULL,
    namecountry character varying NOT NULL
);
    DROP TABLE public.country;
       public         heap    postgres    false            ?            1259    16627    employeeaudit    TABLE     F  CREATE TABLE public.employeeaudit (
    idemployee integer,
    nameemployee character varying,
    branchoffice character varying,
    department character varying,
    supervisor character varying,
    "position" character varying,
    address character varying,
    city character varying,
    country character varying
);
 !   DROP TABLE public.employeeaudit;
       public         heap    postgres    false            ?            1259    16701    historicocargos    VIEW     ?   CREATE VIEW public.historicocargos AS
 SELECT employeeaudit.nameemployee,
    employeeaudit.department,
    employeeaudit.branchoffice
   FROM public.employeeaudit
  WITH LOCAL CHECK OPTION;
 "   DROP VIEW public.historicocargos;
       public          postgres    false    207    207    207            ?          0    16611    adress 
   TABLE DATA           A   COPY public.adress (idaddress, line1, line2, idcity) FROM stdin;
    public          postgres    false    205   ?B       ?          0    16587    branchoffice 
   TABLE DATA           F   COPY public.branchoffice (idbranch, namebranch, idadress) FROM stdin;
    public          postgres    false    202   pC       ?          0    16595    city 
   TABLE DATA           >   COPY public.city (idcity, namecity, fk_idcountry) FROM stdin;
    public          postgres    false    203   ?C       ?          0    16603    country 
   TABLE DATA           9   COPY public.country (idcountry, namecountry) FROM stdin;
    public          postgres    false    204   8D       ?          0    16571 
   department 
   TABLE DATA           8   COPY public.department (iddepartment, name) FROM stdin;
    public          postgres    false    200   ?D       ?          0    16619    employee 
   TABLE DATA           y   COPY public.employee (idemployee, nameemployee, iddepartment, idposition, idaddress, idsupervisor, idbranch) FROM stdin;
    public          postgres    false    206   ?D       ?          0    16627    employeeaudit 
   TABLE DATA           ?   COPY public.employeeaudit (idemployee, nameemployee, branchoffice, department, supervisor, "position", address, city, country) FROM stdin;
    public          postgres    false    207   ?E       ?          0    16579    position 
   TABLE DATA           6   COPY public."position" (idposition, name) FROM stdin;
    public          postgres    false    201   LG                  0    0    Adress_IdAddress_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public."Adress_IdAddress_seq"', 10, true);
          public          postgres    false    209                       0    0    BranchOffice_IdBranch_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public."BranchOffice_IdBranch_seq"', 9, true);
          public          postgres    false    210                       0    0    City_IdCity_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."City_IdCity_seq"', 7, true);
          public          postgres    false    208                       0    0    Department_IdDepartment_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."Department_IdDepartment_seq"', 4, true);
          public          postgres    false    213                       0    0    Employee_IdEmployee_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public."Employee_IdEmployee_seq"', 24, true);
          public          postgres    false    211                       0    0    Position_IdPosition_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."Position_IdPosition_seq"', 4, true);
          public          postgres    false    212            Z           2606    16594    branchoffice pk_branchoffice 
   CONSTRAINT     `   ALTER TABLE ONLY public.branchoffice
    ADD CONSTRAINT pk_branchoffice PRIMARY KEY (idbranch);
 F   ALTER TABLE ONLY public.branchoffice DROP CONSTRAINT pk_branchoffice;
       public            postgres    false    202            ^           2606    16610    country pk_country 
   CONSTRAINT     W   ALTER TABLE ONLY public.country
    ADD CONSTRAINT pk_country PRIMARY KEY (idcountry);
 <   ALTER TABLE ONLY public.country DROP CONSTRAINT pk_country;
       public            postgres    false    204            V           2606    16578    department pk_department 
   CONSTRAINT     `   ALTER TABLE ONLY public.department
    ADD CONSTRAINT pk_department PRIMARY KEY (iddepartment);
 B   ALTER TABLE ONLY public.department DROP CONSTRAINT pk_department;
       public            postgres    false    200            b           2606    16626    employee pk_employee 
   CONSTRAINT     Z   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT pk_employee PRIMARY KEY (idemployee);
 >   ALTER TABLE ONLY public.employee DROP CONSTRAINT pk_employee;
       public            postgres    false    206            `           2606    16618    adress pk_idaddress 
   CONSTRAINT     X   ALTER TABLE ONLY public.adress
    ADD CONSTRAINT pk_idaddress PRIMARY KEY (idaddress);
 =   ALTER TABLE ONLY public.adress DROP CONSTRAINT pk_idaddress;
       public            postgres    false    205            \           2606    16602    city pk_idcity 
   CONSTRAINT     P   ALTER TABLE ONLY public.city
    ADD CONSTRAINT pk_idcity PRIMARY KEY (idcity);
 8   ALTER TABLE ONLY public.city DROP CONSTRAINT pk_idcity;
       public            postgres    false    203            X           2606    16586    position pk_position 
   CONSTRAINT     \   ALTER TABLE ONLY public."position"
    ADD CONSTRAINT pk_position PRIMARY KEY (idposition);
 @   ALTER TABLE ONLY public."position" DROP CONSTRAINT pk_position;
       public            postgres    false    201            j           2620    16713 "   employee mov_employee_triggerafter    TRIGGER     ?   CREATE TRIGGER mov_employee_triggerafter AFTER INSERT OR DELETE OR UPDATE ON public.employee FOR EACH ROW EXECUTE FUNCTION public.mov_employee();
 ;   DROP TRIGGER mov_employee_triggerafter ON public.employee;
       public          postgres    false    206    226            c           2606    16656    branchoffice FK_IdAddress    FK CONSTRAINT     ?   ALTER TABLE ONLY public.branchoffice
    ADD CONSTRAINT "FK_IdAddress" FOREIGN KEY (idadress) REFERENCES public.adress(idaddress) NOT VALID;
 E   ALTER TABLE ONLY public.branchoffice DROP CONSTRAINT "FK_IdAddress";
       public          postgres    false    2912    205    202            i           2606    16678    employee FK_IdAddress    FK CONSTRAINT     ?   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "FK_IdAddress" FOREIGN KEY (idaddress) REFERENCES public.adress(idaddress) NOT VALID;
 A   ALTER TABLE ONLY public.employee DROP CONSTRAINT "FK_IdAddress";
       public          postgres    false    206    2912    205            f           2606    16663    employee FK_IdBranch    FK CONSTRAINT     ?   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "FK_IdBranch" FOREIGN KEY (idbranch) REFERENCES public.branchoffice(idbranch) NOT VALID;
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT "FK_IdBranch";
       public          postgres    false    2906    206    202            e           2606    16649    adress FK_IdCity    FK CONSTRAINT     }   ALTER TABLE ONLY public.adress
    ADD CONSTRAINT "FK_IdCity" FOREIGN KEY (idcity) REFERENCES public.city(idcity) NOT VALID;
 <   ALTER TABLE ONLY public.adress DROP CONSTRAINT "FK_IdCity";
       public          postgres    false    203    2908    205            g           2606    16668    employee FK_IdDepartment    FK CONSTRAINT     ?   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "FK_IdDepartment" FOREIGN KEY (iddepartment) REFERENCES public.department(iddepartment) NOT VALID;
 D   ALTER TABLE ONLY public.employee DROP CONSTRAINT "FK_IdDepartment";
       public          postgres    false    206    200    2902            h           2606    16673    employee FK_IdPosition    FK CONSTRAINT     ?   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT "FK_IdPosition" FOREIGN KEY (idposition) REFERENCES public."position"(idposition) NOT VALID;
 B   ALTER TABLE ONLY public.employee DROP CONSTRAINT "FK_IdPosition";
       public          postgres    false    206    2904    201            d           2606    16638    city Fk_IdCountry    FK CONSTRAINT     ?   ALTER TABLE ONLY public.city
    ADD CONSTRAINT "Fk_IdCountry" FOREIGN KEY (fk_idcountry) REFERENCES public.country(idcountry) NOT VALID;
 =   ALTER TABLE ONLY public.city DROP CONSTRAINT "Fk_IdCountry";
       public          postgres    false    203    2910    204            ?   r   x?e?;?0D??)t????.ivAF?3v??`CG????`??= ??ƾ?4?1?Yd9??r4)kH???i???5??C?l?p?u
????ute?+??<?/V????]??m?z1?      ?   M   x??;
?0??????w???qa??7?L?x????S	?~6Ad?4???s3+?W??K?Tn8??????      ?   [   x?ɹ?0D?x?
*@?n?d8??5?zL???A??BJ??.??@3gt???F?u+Ji0?8q??H??TZ??_h??>j*?s? /w      ?   @   x??I? ?s?cL?~??"$2cF??U3????&.xd?????G?冒??w(?b_3??H???      ?   A   x??I?@?3???xA?	N ?ߪUl?f2?ؤ?2{`?ǧW???!7g??ᦆs?s??      ?   ?   x?]??
?0???a?ݤ?W?Shڋ?R<	??W?!???~??-?????!BR?,Y}?|?#?U??,??Z???5Z6?*??9}^???y?om?cǵ0?????t?ˡ3????'?5Z?}?k[?C?e(???'??2n?1_!?/B      ?   ?  x????N?@???S?ƅ???*Q?Ii/????f	?f????P???"[?ń?0?o???d;RB?EEA???[^V$???\x#H???
??Hq????;$|?r<(8?T?@?`	??d??bob?R^?E?ˎ??	??U+?I^??	H?T%x?s?/?ϴ??4b????AΤ?;1?_?x?x.?Ӭ?ᶢ???3I?L?(??ۛ?<L??+u?|?i?????,%?????????ù??'i?	]A??KT????)?f??|?V"?o3?6?R?`K
???/?WE???\????	j?&9?}/}}?P=?Eö??c????2?{p7?^v??Et?~D~@Z??5lb?1m????zN3k?ږt,??.?' 	??a?m???hx?x???HǷ)?A??U???]?Pas?^?:?I?f??w8
?p??Ζ3|?6?????Ѣ+      ?   2   x?3??JMK?2?L??+IL?/?2?LN??2?LL????,.)???qqq 7?[     