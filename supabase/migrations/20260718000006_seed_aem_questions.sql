-- Seed AEM practice questions from LearnMaster CSV (answers audited; explanations researched)
-- Source: data/aem_practice_questions.csv
DELETE FROM public.questions WHERE source_file_path = 'learnmaster-aem-csv';

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','content-fragments','experience-fragments'], 'behavior prediction',
  $code$/* AEM · content-fragments */
// A customer needs to store approximately 200 raw data items from REST API and display each item as an AEM page. A draft page template exists. Which Method should be used to meet this requirement?$code$,
  'java',
  $stem$A customer needs to store approximately 200 raw data items from REST API and display each item as an AEM page. A draft page template exists. Which Method should be used to meet this requirement?$stem$,
  '[{"text": "Create Experience fragments by binding the data for each item using the draft page template and custom data retrieval logic"}, {"text": "Build a segment using data from REST API call"}, {"text": "Create pages by binding the data for each item using the draft page template and custom data retrieval logic"}, {"text": "Create Content fragments by binding the data for each item using the draft page template and custom data retrieval logic"}]'::jsonb,
  2,
  $exp$Create pages by binding REST data to the existing draft page template. Experience Fragments and Content Fragments are different content types and do not use a Sites page template the same way; ContextHub segments are for personalization, not page creation.$exp$,
  $tp$1) Requirement is one AEM page per API item with an existing page template. 2) Segments are personalization — discard. 3) XF/CF are not page-template page creation — pick Create pages.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','osgi'], 'behavior prediction',
  $code$/* AEM · sling-models */
// An AEM Developer receives requirements for Sling Models in a human-readable yaml format. A custom application needs to be built. The dependency is as shown: <dependency> <groupId> com.fasterxml.jackson.core </groupId> <artifactId> jackson-databind </artifactId$code$,
  'java',
  $stem$An AEM Developer receives requirements for Sling Models in a human-readable yaml format. A custom application needs to be built. The dependency is as shown: <dependency> <groupId> com.fasterxml.jackson.core </groupId> <artifactId> jackson-databind </artifactId> <version> 2.8.4 </version> <scope> provided </scope> </dependency> <dependency> <groupId> com.fasterxml.jackson.dataformat </groupId> <artifactId> jackson-datafirmat-yaml </artifactId> <version> 2.8.4 </version> </dependency>$stem$,
  '[{"text": "1. Create OSGI models to export as yaml. 2. Configure mime type in Apache Sling Servlet/ Script Resolver and Error Handler."}, {"text": "1. Create Sling models to export as yaml. 2. Configure mime type in Apache Sling Referrer Filter."}, {"text": "1. Create OSGI models to export as yaml. 2. Configure mime type in Apache Sling MIME Type Service."}, {"text": "1. Create Sling models to export as yaml. 2. Configure mime type in Apache Sling MIME Type Service."}]'::jsonb,
  3,
  $exp$Exporting Sling Models as YAML needs a Sling Model Exporter implementation (Jackson YAML) plus registering the yaml extension on Apache Sling MIME Type Service. Referrer Filter and Script Resolver are unrelated to MIME mapping.$exp$,
  $tp$1) Stem asks for Sling Models YAML export. 2) Prefer “Sling models” over “OSGI models”. 3) MIME Type Service maps .yaml — not Referrer Filter.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak','security'], 'behavior prediction',
  $code$/* AEM · oak */
// A developer has multiple LDAP Authentication providers. The user is not required to pass the authentication test of the Authentication provider. If authentication succeeds, control is returned to the caller; no subsequent Authentication provider down the list $code$,
  'java',
  $stem$A developer has multiple LDAP Authentication providers. The user is not required to pass the authentication test of the Authentication provider. If authentication succeeds, control is returned to the caller; no subsequent Authentication provider down the list is executed. . If authentication fails, authentication continues down the list of providers. What should be the JAAS Control flag value in Apache Jackrabbit Oak External Login Module configuration?$stem$,
  '[{"text": "OPTIONAL"}, {"text": "SUFFICENT"}, {"text": "REQUIRED"}, {"text": "MANDATORY"}]'::jsonb,
  1,
  $exp$JAAS flag SUFFICIENT means success returns immediately to the caller; failure continues to the next provider. OPTIONAL always continues; REQUIRED/MANDATORY require success and do not match the short-circuit-on-success behavior.$exp$,
  $tp$1) Success stops the chain → SUFFICIENT. 2) Failure continues → not REQUIRED. 3) OPTIONAL never short-circuits on success.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','core-components','editable-templates'], 'behavior prediction',
  $code$/* AEM · core-components */
// An AEM Developer needs to remove the pretitle option from within the Core Teaser components dialog. They start by: A. Creating a component with the Core Teaser component as its resourceSuperType B. Adding a _cq_dialog folder under the component$code$,
  'java',
  $stem$An AEM Developer needs to remove the pretitle option from within the Core Teaser components dialog. They start by: A. Creating a component with the Core Teaser component as its resourceSuperType B. Adding a _cq_dialog folder under the component$stem$,
  '[{"text": "1. create a file named dialog.xml inside that new folder. 2. copy the entire node structure from the Core Teaser component''s dialog.xml 3. delete the pretitle node"}, {"text": "1. create a file named .content.xml inside that new folder. 2. copy only the node structure that will be modified into .content.xml 3. add sling.hideChildren[pretitle] to the parent node of the pretitle node"}, {"text": "1. navigate to the new component''s dialog in CRX 2. delete the pretitle child node"}, {"text": "1. navigate to /apps/core/wcm/components/teaser/v1/teaser/cq:dialog/content/items/tabs/items/text/items/columns/items/column/items in CRX 2. delete the pretitle child node"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: 1. create a file named .content.xml inside that new folder. 2. copy only the node structure that will be modified into .content.xml 3. add sling.hideChildren[pretitle] to the parent node of the pretitle node.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 1. create a file named .content.xml inside that new folder. 2. copy only the node structure that will be modified into .content.xml 3. add s.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// An AEM application wants to be up multi-tenancy using Adobe-recommended best practices and bind multiple configurations to it. Which of the following options is recommended?$code$,
  'java',
  $stem$An AEM application wants to be up multi-tenancy using Adobe-recommended best practices and bind multiple configurations to it. Which of the following options is recommended?$stem$,
  '[{"text": "import org.osgi.service.metatype.annotations.Component: @Component(service = ConfigurationFactory.class)"}, {"text": "Import org.apache.felix.scrannotations.Component: @Component(label = My configuration, metatype=true, factory=true)"}, {"text": "import org.osgi.service.component.annotations.Component:import org.osgi.service.metatype.annotations.Designate: @Component (service = ConfigurationFactory.class)@Designate (ocd= ConfigurationFactoryImpl.Config.class, factory=true)"}, {"text": "import org.osgi.service.metatype.annotations.AttributeDefinition:import org.osgi.service.metatype.annotations.ObjectClassDefinition: @ObjectClassDefinition(name= My configuration)"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: import org.osgi.service.component.annotations.Component:import org.osgi.service.metatype.annotations.Designate: @Component (service = ConfigurationFactory.class)@Designate (ocd= ConfigurationFactoryImpl.Config.class, factory=true).$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: import org.osgi.service.component.annotations.Component:import org.osgi.service.metatype.annotations.Designate: @Component (service = Config.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security','packages'], 'behavior prediction',
  $code$/* AEM · security */
// Which solution should be used to synchronize user permissions across AEM servers?$code$,
  'java',
  $stem$Which solution should be used to synchronize user permissions across AEM servers?$stem$,
  '[{"text": "ACS Commons ACL packager"}, {"text": "Maven Vault plugin"}, {"text": "Acs Commons Authorizable Packager"}, {"text": "User Sync Tool"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: ACS Commons ACL packager.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: ACS Commons ACL packager.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','core-components'], 'behavior prediction',
  $code$/* AEM · core-components */
// A developer has built a dropdown containing each of the fifty U.S. States as a static option. The dialog node is called states. A new requirement is asking to use that same dropdown in another components dialog. Which method would be a more modular approach to$code$,
  'java',
  $stem$A developer has built a dropdown containing each of the fifty U.S. States as a static option. The dialog node is called states. A new requirement is asking to use that same dropdown in another components dialog. Which method would be a more modular approach to the solution?$stem$,
  '[{"text": "copy paste the entire state node from the old component to the new one."}, {"text": "1. Extrapolate out the states node to a more generic location. 2. Set that new location as the resourceSuperType."}, {"text": "copy and paste only the options from the old component to the new one"}, {"text": "1. Extrapolate out the States node to a more generic location. 2. Use granite: include in both components to bring in only what is needed"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: 1. Extrapolate out the States node to a more generic location. 2. Use granite: include in both components to bring in only what is needed.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 1. Extrapolate out the States node to a more generic location. 2. Use granite: include in both components to bring in only what is needed.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','spa','archetype'], 'behavior prediction',
  $code$/* AEM · spa */
// An AEM Developer is setting up a new AEM Project for a custom SPA that will utilize the SPA Editor. Which command should the developer use?$code$,
  'java',
  $stem$An AEM Developer is setting up a new AEM Project for a custom SPA that will utilize the SPA Editor. Which command should the developer use?$stem$,
  '[{"text": "mvn archetype: generate \\ -D archetypeGroupId=com.adobe.granite.archetypes \\ -D archetypeArtifactId=aem-project-archetype \\ -D archetypeVersion=23 \\ -D frontendModule=react"}, {"text": "mvn -B archetype: generate \\ -D archetypeGroupId=com.adobe.granite.archetypes \\ -D archetypeArtifactId=aem-project-archetype \\ -D archetypeVersion=23 \\ -D frontendModule=angular"}, {"text": "mvn archetype: generate \\ -D archetypeGroupId=com.adobe.granite.archetypes \\ -D archetypeArtifactId=aem-project-archetype \\ -D archetypeVersion=23 \\ -D frontendModule=general"}, {"text": "mvn -B archetype: generate \\ -D archetypeGroupId=com.adobe.granite.archetypes \\ -D archetypeArtifactId=aem-project-archetype \\ -D archetypeVersion=23 \\ -D sdkVersione=latest"}]'::jsonb,
  0,
  $exp$For an AEM Project Archetype SPA Editor app, set -DfrontendModule=react (or angular if Angular). React is the usual Adobe SPA Editor example; include -B for non-interactive generation when scripting.$exp$,
  $tp$1) Need SPA Editor frontend module. 2) Discard options missing a real SPA module. 3) Prefer react for a generic custom SPA unless Angular is specified.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','spa'], 'behavior prediction',
  $code$/* AEM · spa */
// A project requires sharing information between SPA components. Which is the least complex approach to achieve that objective?$code$,
  'java',
  $stem$A project requires sharing information between SPA components. Which is the least complex approach to achieve that objective?$stem$,
  '[{"text": "Utilize model props to drill down and access or set the state on desired components."}, {"text": "Centralize the logic and broadcast to the necessary components."}, {"text": "Implement a state library in order to share component states."}, {"text": "Customize and extend the container component to leverage the object hierarchy."}]'::jsonb,
  1,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: Centralize the logic and broadcast to the necessary components..$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Centralize the logic and broadcast to the necessary components..$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','oak','osgi','security'], 'behavior prediction',
  $code$/* AEM · oak */
// An AEM application requires LDAP Service integration to synchronize users/groups. Which two OSGI configuration are required for LDAP integration in AEM?(Choose Two.)$code$,
  'java',
  $stem$An AEM application requires LDAP Service integration to synchronize users/groups. Which two OSGI configuration are required for LDAP integration in AEM?(Choose Two.)$stem$,
  '[{"text": "Apache Jackrabbit Oak Default Sync Handler"}, {"text": "Apache Jackrabbit Oak Solr server provider"}, {"text": "Apache Jackrabbit Oak CUG Configuration"}, {"text": "Apache Jackrabbit Oak AuthorizableActionProvider"}, {"text": "Apache Jackrabbit Oak External Login Module"}]'::jsonb,
  4,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: Apache Jackrabbit Oak External Login Module. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Apache Jackrabbit Oak External Login Module.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','dispatcher'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// Which configuration/section should be used to resolve the domain name by dispatcher?$code$,
  'java',
  $stem$Which configuration/section should be used to resolve the domain name by dispatcher?$stem$,
  '[{"text": "Configuration in httpd.conf"}, {"text": "Configuration in vhosts file"}, {"text": "Configuration in DNS"}, {"text": "Configuration in filter.any"}]'::jsonb,
  1,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: Configuration in vhosts file.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Configuration in vhosts file.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Which configuration takes precedence at runtime, When multiple configurations exist in AEM?$code$,
  'java',
  $stem$Which configuration takes precedence at runtime, When multiple configurations exist in AEM?$stem$,
  '[{"text": "Any .config files from <cq-installation-dir>/crx-quickstart/launchpad/config/.... On the local"}, {"text": "Repository nodes with type sling:OsgiConfig under /libs/*/config"}, {"text": "Configuration that exist in the Web Console"}, {"text": "Repository nodes under /apps/*/config"}]'::jsonb,
  2,
  $exp$At runtime, OSGi configs edited in the Web Console override repository configs under /apps and /libs until restart/persist rules apply. /apps still beats /libs for deployed configs, but the console is the highest live precedence among the listed options.$exp$,
  $tp$1) Compare launchpad files, /libs, Web Console, /apps. 2) Live console edits win at runtime. 3) Pick Web Console.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','editable-templates'], 'behavior prediction',
  $code$/* AEM · editable-templates */
// A developer needs to make template T available as a child page of page P. The developer has determined that: Template T matches cq:allowedTemplates property on page P. Template T has no atlowedPaths Property set. Template T is not in the same application as pa$code$,
  'java',
  $stem$A developer needs to make template T available as a child page of page P. The developer has determined that: Template T matches cq:allowedTemplates property on page P. Template T has no atlowedPaths Property set. Template T is not in the same application as page P. The template of page P has no match on the allowedParents property of template T. Template T has no match on the allowedTemplate property on the temptate of page P. What should the developer change?$stem$,
  '[{"text": "Make the allowedParents property of template T match the template of page P."}, {"text": "Make Page P match allowedPaths property of template T."}, {"text": "Clear the attowedParents property of template T."}, {"text": "Migrate template T to the same application as Page P."}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Clear the attowedParents property of template T..$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Clear the attowedParents property of template T..$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// An AEM developer sets an arguments variable myVariable to be consumed by workflow process in the same workflow model definition.$code$,
  'java',
  $stem$An AEM developer sets an arguments variable myVariable to be consumed by workflow process in the same workflow model definition.$stem$,
  '[{"text": "//GET myVariable from args String args = metaDataMap.get(PROCESS_ARGS, String.class);"}, {"text": "//GET myVariable directly from MetaDataMap String myVariable = workItem.getMetaDataMap().get(myVariable);"}, {"text": "//GET myVariable from HistoryItem object List < HistoryItem>history = workflowSession.getHistory(workItem.getWorkflow());"}, {"text": "//GET myVariable from WorkflowData String myVariable = workItem.getWorkflowData.getPayload90.toString();"}]'::jsonb,
  0,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: //GET myVariable from args String args = metaDataMap.get(PROCESS_ARGS, String.class);.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: //GET myVariable from args String args = metaDataMap.get(PROCESS_ARGS, String.class);.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','testing'], 'behavior prediction',
  $code$/* AEM · testing */
// An AEM Developer needs to automate tests for the user interface. Which tool is provided in the AEM Framework for automated UI testing?$code$,
  'java',
  $stem$An AEM Developer needs to automate tests for the user interface. Which tool is provided in the AEM Framework for automated UI testing?$stem$,
  '[{"text": "Sinon"}, {"text": "Jasmine"}, {"text": "HobbesJS"}, {"text": "Mocha"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: HobbesJS.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: HobbesJS.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','cloud-service','core-components'], 'behavior prediction',
  $code$/* AEM · cloud-service */
// An AEM application development team is assigned a task to create an Event-Driven Data Layer implementation for an analytics solution. Which Adobe recommended best practice should the developer choose?$code$,
  'java',
  $stem$An AEM application development team is assigned a task to create an Event-Driven Data Layer implementation for an analytics solution. Which Adobe recommended best practice should the developer choose?$stem$,
  '[{"text": "Use Adobe Client Data Layer and Integrate with Core components"}, {"text": "Use Adobe Experience Platform''s data layer to integrate with AEM"}, {"text": "Create an Adobe Cloud Service configurations to use third-party tools data layer"}, {"text": "Create a custom data layer and each component, template and its properties to the data layer"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Use Adobe Client Data Layer and Integrate with Core components.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Use Adobe Client Data Layer and Integrate with Core components.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// An AEM Developer needs to create a log file for the project. Which next step should the developer take?$code$,
  'java',
  $stem$An AEM Developer needs to create a log file for the project. Which next step should the developer take?$stem$,
  '[{"text": "Create a log file under /libs/system/configuration... specific runmode folder(s)"}, {"text": "Create a log file under /apps/system/configuration... specific runmode folder(s)"}, {"text": "Ask AMS/DevOps for admin access to create a log file via console"}, {"text": "Create a log file under /apps/myproject/configuration... specific runmode folder(s)"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Create a log file under /apps/myproject/configuration... specific runmode folder(s).$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Create a log file under /apps/myproject/configuration... specific runmode folder(s).$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// What type of configuration can be created in OSGI Configuration Manager?$code$,
  'java',
  $stem$What type of configuration can be created in OSGI Configuration Manager?$stem$,
  '[{"text": "Run modes Configuration"}, {"text": "Service Configuration"}, {"text": "Components Configurations"}, {"text": "Bundles Configurations"}]'::jsonb,
  1,
  $exp$OSGi Configuration Manager is used to create/edit service configurations (including factory PIDs). Run modes are folder conventions; “bundles configurations” is not the primary Config Manager artifact type.$exp$,
  $tp$1) Config Manager edits service PIDs. 2) Run modes are not created there. 3) Choose Service Configuration.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// AMS recommends a team to upgrade AEM servers with in-place upgrade because the existing version has reached EOL. What are two disadvantages of performing an in-place Upgrade to the latest version of AEM?(Choose two.)$code$,
  'java',
  $stem$AMS recommends a team to upgrade AEM servers with in-place upgrade because the existing version has reached EOL. What are two disadvantages of performing an in-place Upgrade to the latest version of AEM?(Choose two.)$stem$,
  '[{"text": "Content migration is required."}, {"text": "Content revision history is not preserved."}, {"text": "Depending on the version difference between the old and new instances, the upgrade can be a long and arduous process."}, {"text": "ACLs, users, and groups are lost"}, {"text": "Complex developers setup and automation of the upgrade process."}]'::jsonb,
  4,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Complex developers setup and automation of the upgrade process.. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Complex developers setup and automation of the upgrade process..$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','spa'], 'behavior prediction',
  $code$/* AEM · sling-models */
// SPA components are connected to MM components via the MapTo0 method. Which code should be used to correctly connect an SPA component called Itembst to its MM equivalent?$code$,
  'java',
  $stem$SPA components are connected to MM components via the MapTo0 method. Which code should be used to correctly connect an SPA component called Itembst to its MM equivalent?$stem$,
  '[{"text": "MapTo(''project/components/content/itemList'')(ItemList. ItemListEditConfig);"}, {"text": "MapTo(ItemList)(''project/components/content/itemList'',ItemListEditConfig):"}, {"text": "(''project/components/content/itemList'').MapTo(ItemList,ItemListEditConfig);"}, {"text": "ItemList.MapTo(''project/components/content/itemList''):"}]'::jsonb,
  0,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: MapTo('project/components/content/itemList')(ItemList. ItemListEditConfig);.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: MapTo('project/components/content/itemList')(ItemList. ItemListEditConfig);.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','packages','cloud-service'], 'behavior prediction',
  $code$/* AEM · osgi */
// The OSGi configuration is added to a run mode specific configuration config.author.staging in AEM as a Cloud service. This application fails to read the configuration. What is the possible cause of the issue?$code$,
  'java',
  $stem$The OSGi configuration is added to a run mode specific configuration config.author.staging in AEM as a Cloud service. This application fails to read the configuration. What is the possible cause of the issue?$stem$,
  '[{"text": "The custom OSGi configuration runmode used (i.e., config.author.staging) is not supported in AEM as a Cloud service"}, {"text": "Only <service> Specific OSGI configuration runmodes like config.author OR config.publish are supported in AEM as a Cloud service."}, {"text": "OSGi configurations runmodes cannot be installed automatically on AEM as a Cloud Service we need to install them as a package using the package manager"}, {"text": "AEM as a Cloud service does not support OSGi configuration runmodes"}]'::jsonb,
  0,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: The custom OSGi configuration runmode used (i.e., config.author.staging) is not supported in AEM as a Cloud service.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: The custom OSGi configuration runmode used (i.e., config.author.staging) is not supported in AEM as a Cloud service.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','osgi','archetype','packages'], 'behavior prediction',
  $code$/* AEM · osgi */
// AS per Latest AEM archetype what are two primary purpose of the it:launcher module? (Choose Two)$code$,
  'java',
  $stem$AS per Latest AEM archetype what are two primary purpose of the it:launcher module? (Choose Two)$stem$,
  '[{"text": "Bundle up the code that deploys ui.tests to the server"}, {"text": "Package up JUnit tests that will later be executed server-side"}, {"text": "Bundle all Hobbes tests for automating UI tests"}, {"text": "Hold all mock data used for Junit testing"}, {"text": "Trigger remote Junit execution"}]'::jsonb,
  4,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Trigger remote Junit execution. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Trigger remote Junit execution.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages','replication'], 'behavior prediction',
  $code$/* AEM · packages */
// Which option should be used to synchronize user data across publish servers in a publish farm?$code$,
  'java',
  $stem$Which option should be used to synchronize user data across publish servers in a publish farm?$stem$,
  '[{"text": "Using Vault plugin"}, {"text": "Using Sling Distribution"}, {"text": "Replication Agents"}, {"text": "Using CURL"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Using Sling Distribution.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Using Sling Distribution.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak','testing'], 'behavior prediction',
  $code$/* AEM · oak */
// An AEM Developer creates a custom OAK index for /content/mywebsite under /oak:index node. While testing the live site. It is found that the index is not being applied to any query within the website. Default Lucene indexes with high cost are being picked up by$code$,
  'java',
  $stem$An AEM Developer creates a custom OAK index for /content/mywebsite under /oak:index node. While testing the live site. It is found that the index is not being applied to any query within the website. Default Lucene indexes with high cost are being picked up by the AEM. What is the most likely of the issue?$stem$,
  '[{"text": "The custom OAK Lucene index must be replaced with OAK Lucene Property index"}, {"text": "The Custom Oak Lucene index must include boost property to rank it higher than default Lucene index"}, {"text": "The Custom OAK Lucene index is missing evaluatePathRestrictions property and queryPaths property"}, {"text": "The Custom OAK lucene index is missing evaluatePathRestrictions property and includedPaths Property"}]'::jsonb,
  2,
  $exp$Path-restricted custom Lucene indexes must declare evaluatePathRestrictions and appropriate queryPaths (and related path settings) or Oak falls back to expensive default indexes.$exp$,
  $tp$1) Index exists but unused → definition incomplete. 2) Path restriction flags/paths missing. 3) Prefer evaluatePathRestrictions + queryPaths over replacing index type.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','packages'], 'behavior prediction',
  $code$/* AEM · osgi */
// A Custom application contains Bundle A and Bundle B. Bundle A has a dependency to Bundle B via Import-Package. How can both bundles be deployed most efficiently across all the environments?$code$,
  'java',
  $stem$A Custom application contains Bundle A and Bundle B. Bundle A has a dependency to Bundle B via Import-Package. How can both bundles be deployed most efficiently across all the environments?$stem$,
  '[{"text": "Create one content package per bundle and use a package dependency to ensure installation order"}, {"text": "Embed both bundles in one content package and user property installationOrder in package properties for correct bundle installation order"}, {"text": "Embed both bundles in one content package the dependency via import-Package is enough to ensure correct installation"}, {"text": "Use the Felix Web Console to upload the bundle in the correct order"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Create one content package per bundle and use a package dependency to ensure installation order.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Create one content package per bundle and use a package dependency to ensure installation order.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','sling-models','spa'], 'behavior prediction',
  $code$/* AEM · sling-models */
// AEM SPAs PageModelManager leverages the JSON MODEL EXPORTER. Which two meta field are exposed through that exporter? (Choose Two)$code$,
  'java',
  $stem$AEM SPAs PageModelManager leverages the JSON MODEL EXPORTER. Which two meta field are exposed through that exporter? (Choose Two)$stem$,
  '[{"text": "parent"}, {"text": "resource"}, {"text": "type"}, {"text": "length"}, {"text": "children"}]'::jsonb,
  4,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: children. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: children.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages','editable-templates'], 'behavior prediction',
  $code$/* AEM · packages */
// While Working Editable Templates, the author reports that the changes that the author makes are lost periodically. What should the AEM Developer fix to prevent losing author updates?$code$,
  'java',
  $stem$While Working Editable Templates, the author reports that the changes that the author makes are lost periodically. What should the AEM Developer fix to prevent losing author updates?$stem$,
  '[{"text": "Set mode to be merge in the filter.xml"}, {"text": "Set mode to be update in the filter.xml"}, {"text": "Move the affected editable template to etc/templates"}, {"text": "Move the affected editable template to apps/templates"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Set mode to be merge in the filter.xml.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Set mode to be merge in the filter.xml.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','content-fragments','experience-fragments'], 'behavior prediction',
  $code$/* AEM · sling-models */
// AEM supports traditional, Headless and Hybrid delivery capabilities in various ways. Which of the following are the tools enabling Omnichannel experience capabilities in AEM ?$code$,
  'java',
  $stem$AEM supports traditional, Headless and Hybrid delivery capabilities in various ways. Which of the following are the tools enabling Omnichannel experience capabilities in AEM ?$stem$,
  '[{"text": "1. Sling Modal Exporter for Content Fragments and Experience Fragments 2. AEM Assets HTTP API 3. GraphsQL API for content Fragments and Experience Fragments"}, {"text": "1. Sling Modal Exporter for Content Fragments and Experience Fragments 2. GraphsQL API for Content Fragments and Experience Fragments 3. Content Services"}, {"text": "1. AEM Assets HTTP API 2. GraphsQL API for content Fragments and Experience Fragments 3. Content Services"}, {"text": "1. Sling Modal Exporter for Content Fragments and Experience Fragments 2. AEM Assets HTTP API 3. Content Services"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: 1. AEM Assets HTTP API 2. GraphsQL API for content Fragments and Experience Fragments 3. Content Services.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 1. AEM Assets HTTP API 2. GraphsQL API for content Fragments and Experience Fragments 3. Content Services.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','clientlibs'], 'behavior prediction',
  $code$/* AEM · clientlibs */
// A customer adds third-party client libraries to add some features in an existing AEM application which will significantly reduce performance What is the best option for the AEM Developer to optimize the site?$code$,
  'java',
  $stem$A customer adds third-party client libraries to add some features in an existing AEM application which will significantly reduce performance What is the best option for the AEM Developer to optimize the site?$stem$,
  '[{"text": "Embed client libraries to consolidate them into fewer files"}, {"text": "Debug third-party client lib and fix the code"}, {"text": "Create new AEM application from Scratch"}, {"text": "Rebuild Client libraries"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Embed client libraries to consolidate them into fewer files.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Embed client libraries to consolidate them into fewer files.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// An AEM application must process a high volume of content ingestion on the author server. What is a key factor to optimize a design for overall performance gain for implementing workflows?$code$,
  'java',
  $stem$An AEM application must process a high volume of content ingestion on the author server. What is a key factor to optimize a design for overall performance gain for implementing workflows?$stem$,
  '[{"text": "Allocate more RAM for the content ingestion up front"}, {"text": "Run Garbage collection every time content ingestion occurs"}, {"text": "Use Schedulers to run the workflow only on weekends"}, {"text": "Use Transient workflows"}]'::jsonb,
  3,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: Use Transient workflows.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Use Transient workflows.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','core-components'], 'behavior prediction',
  $code$/* AEM · core-components */
// A developer wants to extend a core component so what property that developer has to use?$code$,
  'java',
  $stem$A developer wants to extend a core component so what property that developer has to use?$stem$,
  '[{"text": "Sling:resourceType"}, {"text": "Sling:resourceSuperType"}, {"text": "Placeholder answer since Platform does not support 2 answers"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Sling:resourceSuperType.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Sling:resourceSuperType.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','core-components'], 'behavior prediction',
  $code$/* AEM · core-components */
// A developer has a requirement of custom component which needs whole core component functionality but only one tab is not required. So which property can be used for this purpose?$code$,
  'java',
  $stem$A developer has a requirement of custom component which needs whole core component functionality but only one tab is not required. So which property can be used for this purpose?$stem$,
  '[{"text": "Sling:orderBefore"}, {"text": "Sling:hideResource"}, {"text": "Sling:hideChildren"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Sling:hideResource.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Sling:hideResource.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// A Project has a transient workflow. But a specific step defeats the purpose of making workflow to transient. creates a sling job to proceed further and generates error messages in log files. To make it better which step must be removed?$code$,
  'java',
  $stem$A Project has a transient workflow. But a specific step defeats the purpose of making workflow to transient. creates a sling job to proceed further and generates error messages in log files. To make it better which step must be removed?$stem$,
  '[{"text": "Participant Step"}, {"text": "Process Step"}, {"text": "Container Step"}, {"text": "Participant Chooser Step"}]'::jsonb,
  1,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: Process Step.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Process Step.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','htl'], 'behavior prediction',
  $code$/* AEM · htl */
// Developer wants to print Hello World in only edit mode. What should be the HTL?$code$,
  'java',
  $stem$Developer wants to print Hello World in only edit mode. What should be the HTL?$stem$,
  '[{"text": "data-sly-test=${wcmmode.editor}"}, {"text": "data-sly-test=${wcmmode.edit}"}, {"text": "data-sly-test=${wcm.edit}"}]'::jsonb,
  1,
  $exp$HTL (Sightly) uses data-sly-* block statements and expression language; the correct syntax/option is: data-sly-test=${wcmmode.edit}.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: data-sly-test=${wcmmode.edit}.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// An AEM application must be highly available and scalable in distributed geographical scenario. Which approach should be used to meet the requirement?$code$,
  'java',
  $stem$An AEM application must be highly available and scalable in distributed geographical scenario. Which approach should be used to meet the requirement?$stem$,
  '[{"text": "Oak Cluster with MongoMK Failover Across Multiple Datacenters"}, {"text": "TarMK Cold Standby"}, {"text": "TarMK Farm"}, {"text": "Oak Cluster with MongoMK Failover in a Single Datacenter"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Oak Cluster with MongoMK Failover Across Multiple Datacenters.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Oak Cluster with MongoMK Failover Across Multiple Datacenters.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','htl'], 'behavior prediction',
  $code$/* AEM · sling-models */
// What a developer must use to use jcr:property in java variable?$code$,
  'java',
  $stem$What a developer must use to use jcr:property in java variable?$stem$,
  '[{"text": "Sling Model"}, {"text": "Crx De"}, {"text": "HTL"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Sling Model.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Sling Model.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models'], 'behavior prediction',
  $code$/* AEM · sling-models */
// A developer wants to consume AEM Page Data in a Single Page Application. The Single page Application is coded to understand JSON format. Only page content should be exposed through JSON. All the existing components are based on foundation components. Which cha$code$,
  'java',
  $stem$A developer wants to consume AEM Page Data in a Single Page Application. The Single page Application is coded to understand JSON format. Only page content should be exposed through JSON. All the existing components are based on foundation components. Which change should the developer make in the existing components to support this requirement?$stem$,
  '[{"text": "Implement a sling Model Exporter for the components"}, {"text": "Invoke the page URL with the extension json to get the values to construct the required output"}, {"text": "Create a custom sling event handler to handle JSON requests"}, {"text": "Add JSON as the default extension in Apache Sling Servlet/Script Resolver and Error Handler Configuration"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Implement a sling Model Exporter for the components.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Implement a sling Model Exporter for the components.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem','packages'], 'behavior prediction',
  $code$/* AEM · packages */
// What is the default value for AC Handling when creating packages?$code$,
  'java',
  $stem$What is the default value for AC Handling when creating packages?$stem$,
  '[{"text": "Overwrite"}, {"text": "MergePreserve"}, {"text": "Ignore"}, {"text": "Merge"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Ignore.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Ignore.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','htl'], 'behavior prediction',
  $code$/* AEM · htl */
// A developer wants to replace element name of host element with titleLevel property of model in HTL. What should be the HTL for the same.$code$,
  'java',
  $stem$A developer wants to replace element name of host element with titleLevel property of model in HTL. What should be the HTL for the same.$stem$,
  '[{"text": "<div data-sly-element= ${titleLevel} @context= something></div>"}, {"text": "<data-sly-use.element= ${titleLevel}></div>"}, {"text": "<div data-sly-attribute= ${titleLevel}></div>"}]'::jsonb,
  0,
  $exp$HTL (Sightly) uses data-sly-* block statements and expression language; the correct syntax/option is: <div data-sly-element= ${titleLevel} @context= something></div>.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: <div data-sly-element= ${titleLevel} @context= something></div>.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','htl','core-components'], 'behavior prediction',
  $code$/* AEM · htl */
// An AEM Developer needs to create a new component to help support a new product launch. The client is on AEM 6.5 on-premise with the latest version of WCM Core Components The component must include text, image, and a link The component must support multiple des$code$,
  'java',
  $stem$An AEM Developer needs to create a new component to help support a new product launch. The client is on AEM 6.5 on-premise with the latest version of WCM Core Components The component must include text, image, and a link The component must support multiple designs Which process should the AEM Developer use to support the launch?$stem$,
  '[{"text": "1. Create a new component by extending the Text Component from Core Components 2. Add dialog properties and modify HTL to support images"}, {"text": "1. Extend the Text Component from Core Components 2. Enable image manipulations for the Text Component via policy"}, {"text": "1. Extend the Teaser Component from Core Components 2. Create style variations to be used in the Style System"}, {"text": "1. Create a new Image with Text component that exposes the Core Components authoring dialogs for those components 2. Add a policy to define which designs are used"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: 1. Extend the Teaser Component from Core Components 2. Create style variations to be used in the Style System.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 1. Extend the Teaser Component from Core Components 2. Create style variations to be used in the Style System.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','workflow'], 'behavior prediction',
  $code$/* AEM · osgi */
// An AEM server is overloaded with too many concurrently running workflows. The developer decides to reduce the number of concurrent workflows. What should be configured to reduce the number of concurrent workflows?$code$,
  'java',
  $stem$An AEM server is overloaded with too many concurrently running workflows. The developer decides to reduce the number of concurrent workflows. What should be configured to reduce the number of concurrent workflows?$stem$,
  '[{"text": "The number of threads in scheduler"}, {"text": "Launchers for each workflow"}, {"text": "The number of threads in Apache Felix Jetty Http Service"}, {"text": "Maximum parallel jobs in OSGI console"}]'::jsonb,
  3,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: Maximum parallel jobs in OSGI console.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Maximum parallel jobs in OSGI console.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','workflow','testing'], 'behavior prediction',
  $code$/* AEM · workflow */
// An AEM application must implement user testing using AEM Mocks. Which two service does the Class AemContext provide developers access to?(Choose two.)$code$,
  'java',
  $stem$An AEM application must implement user testing using AEM Mocks. Which two service does the Class AemContext provide developers access to?(Choose two.)$stem$,
  '[{"text": "FlushAgent"}, {"text": "WorkflowSession"}, {"text": "ModelFactory"}, {"text": "TagManager"}, {"text": "Session"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: TagManager. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: TagManager.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// While using the custom workflow model on multiple assets / pages , workflow instance is getting started for each asset/page. Which property can be enabled to start a single workflow instance if multiple assets / pages are subjected?$code$,
  'java',
  $stem$While using the custom workflow model on multiple assets / pages , workflow instance is getting started for each asset/page. Which property can be enabled to start a single workflow instance if multiple assets / pages are subjected?$stem$,
  '[{"text": "Multi-Resource Support"}, {"text": "Transient Workflow"}, {"text": "Multi-Resource Helper"}]'::jsonb,
  0,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: Multi-Resource Support.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Multi-Resource Support.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// Author has OSGI component: @Component ( service = Servlet . class , property ={ ServletResolverConstants . SLING_SERVLET_PATHS +..... something ServletResolverConstants . SLING_SERVLET_METHODS + something ...}) public class SomeServlet { .............. } How c$code$,
  'java',
  $stem$Author has OSGI component: @Component ( service = Servlet . class , property ={ ServletResolverConstants . SLING_SERVLET_PATHS +..... something ServletResolverConstants . SLING_SERVLET_METHODS + something ...}) public class SomeServlet { .............. } How can author use Apache felix web console to disable servlet?$stem$,
  '[{"text": "Component tab>Check OSGi component is listed>click disable"}, {"text": "Bundle Resource provider tab>Check OSGi component is listed>click disable"}, {"text": "Service tab>Check OSGi component is listed>click disable"}]'::jsonb,
  0,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: Component tab>Check OSGi component is listed>click disable.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Component tab>Check OSGi component is listed>click disable.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages'], 'behavior prediction',
  $code$/* AEM · packages */
// Where Should an AEM Developer add a front-end dependency?$code$,
  'java',
  $stem$Where Should an AEM Developer add a front-end dependency?$stem$,
  '[{"text": "vault.xml"}, {"text": "settings.xml"}, {"text": "package.json"}, {"text": "config.json"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: package.json.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: package.json.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','core-components'], 'behavior prediction',
  $code$/* AEM · core-components */
// A developer wants a custom component that has functionality of core component so what component he needs to create?$code$,
  'java',
  $stem$A developer wants a custom component that has functionality of core component so what component he needs to create?$stem$,
  '[{"text": "Proxy Component"}, {"text": "Core component"}, {"text": "Custom Component"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Proxy Component.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Proxy Component.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','sling-models'], 'behavior prediction',
  $code$/* AEM · sling-models */
// What will be the correct syntax for getting request attribute in sling model? (choose two)$code$,
  'java',
  $stem$What will be the correct syntax for getting request attribute in sling model? (choose two)$stem$,
  '[{"text": "@Inject @Source(request-attributes) @Named(testParam)"}, {"text": "@Inject(name= testParam)"}, {"text": "@RequestAttribute(testParam)"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: @RequestAttribute(testParam). The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: @RequestAttribute(testParam).$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// An AEM application is required to create absolute urls for the web domain on which the application is supported to run. The developer wants to create the absolute urls in the server to facilitate other use cases for SEO and Analytics Which of the following opt$code$,
  'java',
  $stem$An AEM application is required to create absolute urls for the web domain on which the application is supported to run. The developer wants to create the absolute urls in the server to facilitate other use cases for SEO and Analytics Which of the following options would work for the developer?$stem$,
  '[{"text": "Configure apache rewrite rules to create the absolute urls"}, {"text": "Configure Day CQ Link Externalizer to add a domain mapping to Author Server and Publisher"}, {"text": "Configure Day CQ Link Externalizer to remove the author domain"}, {"text": "Configure Day CQ Link Externalizer to add a domain mapping to Publisher/Web Server"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Configure Day CQ Link Externalizer to add a domain mapping to Publisher/Web Server.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Configure Day CQ Link Externalizer to add a domain mapping to Publisher/Web Server.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak','osgi','security'], 'behavior prediction',
  $code$/* AEM · oak */
// What is Out of Scope for the Pattern Detector tool, while doing an AEM upgrade?$code$,
  'java',
  $stem$What is Out of Scope for the Pattern Detector tool, while doing an AEM upgrade?$stem$,
  '[{"text": "OSGI bundles exports and imports mismatch"}, {"text": "Backward Compatibility with the previous AEM version"}, {"text": "Rep:User nodes compatibility(in context of OAuth configuration)"}, {"text": "Definitions of Oak indices for compatibility"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Backward Compatibility with the previous AEM version.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Backward Compatibility with the previous AEM version.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','archetype'], 'behavior prediction',
  $code$/* AEM · archetype */
// Where a developer needs to write the business logic in java?$code$,
  'java',
  $stem$Where a developer needs to write the business logic in java?$stem$,
  '[{"text": "Core"}, {"text": "Ui.apps"}, {"text": "Ui.config"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Core.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Core.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','archetype'], 'behavior prediction',
  $code$/* AEM · archetype */
// A Client has asked to share an HTML Version of test coverage report for the AEM project. What plugin should the AEM developer use to generate test coverage report using latest archetype?$code$,
  'java',
  $stem$A Client has asked to share an HTML Version of test coverage report for the AEM project. What plugin should the AEM developer use to generate test coverage report using latest archetype?$stem$,
  '[{"text": "<plugin> <groupId>org.apache.maven.plugins</groupId> <artifactId>maven-pmd-plugin</artifactId>.....</plugin>"}, {"text": "<plugin> <groupId>org.apache.maven.plugins</groupId> <artifactId>maven-checkstyle- plugin</artifactId>.....</plugin>"}, {"text": "<plugin> <groupId>org.apache.maven.plugins</groupId> <artifactId>maven-surefire-plugin</artifactId>.....</plugin>"}, {"text": "<plugin> <groupId>org.codehaus.mojo</groupId> <artifactId>selenium-maven-plugin</artifactId>.....</plugin>"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: <plugin> <groupId>org.apache.maven.plugins</groupId> <artifactId>maven-surefire-plugin</artifactId>.....</plugin>.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: <plugin> <groupId>org.apache.maven.plugins</groupId> <artifactId>maven-surefire-plugin</artifactId>.....</plugin>.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','packages'], 'behavior prediction',
  $code$/* AEM · osgi */
// Which tool allows assets to be shared with multiple AEM instances as read-only local assets?$code$,
  'java',
  $stem$Which tool allows assets to be shared with multiple AEM instances as read-only local assets?$stem$,
  '[{"text": "Package Manager"}, {"text": "Connected Assets"}, {"text": "Asset Link Share"}, {"text": "Felix Console"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Connected Assets.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Connected Assets.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// How to get metadata of workflow by using java snippet?$code$,
  'java',
  $stem$How to get metadata of workflow by using java snippet?$stem$,
  '[{"text": "WorkflowDataMap wfd = workflowItem.getWorkFlow().getMetaDataMap(); wfd.Put(key, Value);"}, {"text": "WorkflowDataMap wfd = workflowItem.getMetaDataMap(); wfd.Put(key, Value);"}, {"text": "WorkflowDataMap wfd = workflowItem.getWorkflow().getWorkflowData().getMetaDataMap(); wfd.Put(key, Value);"}]'::jsonb,
  2,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: WorkflowDataMap wfd = workflowItem.getWorkflow().getWorkflowData().getMetaDataMap(); wfd.Put(key, Value);.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: WorkflowDataMap wfd = workflowItem.getWorkflow().getWorkflowData().getMetaDataMap(); wfd.Put(key, Value);.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem','dispatcher','replication'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// Which URI should be used to configure a Flush Agent for a dispatcher listening on port 8080?$code$,
  'java',
  $stem$Which URI should be used to configure a Flush Agent for a dispatcher listening on port 8080?$stem$,
  '[{"text": "http://<dispatcherHost>:8080/invalidate.cache"}, {"text": "http://<dispatcherHost>:8080/dispatcher/invalidate.cache"}, {"text": "http://<dispatcherHost>:8080/dispatcher/cache.invalidate"}, {"text": "http://<dispatcherHost>:8080/cache.invalidate"}]'::jsonb,
  1,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: http://<dispatcherHost>:8080/dispatcher/invalidate.cache.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: http://<dispatcherHost>:8080/dispatcher/invalidate.cache.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// An AEM application requires a service user WRITE access to children nodes but not on the parent node itself. Which console should the developer use to apply appropriate ACL?$code$,
  'java',
  $stem$An AEM application requires a service user WRITE access to children nodes but not on the parent node itself. Which console should the developer use to apply appropriate ACL?$stem$,
  '[{"text": "User Management console"}, {"text": "Group Management console"}, {"text": "OAuth Clients console"}, {"text": "Permission console"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Permission console.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Permission console.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// A developer is using sling context-aware configuration trying to get the configuration resource using: @Reference Private configurationResourceResolver cfgResourceResolver ; confResource = cfgResourceResolver . getResource ( resource , Bucket_NAME , CONFIG_NAM$code$,
  'java',
  $stem$A developer is using sling context-aware configuration trying to get the configuration resource using: @Reference Private configurationResourceResolver cfgResourceResolver ; confResource = cfgResourceResolver . getResource ( resource , Bucket_NAME , CONFIG_NAME ); This works as intended in author and in publish when logged in to publish as admin. However this gives a null when run as anonymous.$stem$,
  '[{"text": "Apply read permissions to anonymous user for /content directory"}, {"text": "Apply read permissions to anonymous user for /conf directory"}, {"text": "Apply read permissions to anonymous user for /etc directory"}, {"text": "Apply write permissions to anonymous user for /conf directory"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Apply read permissions to anonymous user for /etc directory.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Apply read permissions to anonymous user for /etc directory.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','content-fragments'], 'behavior prediction',
  $code$/* AEM · content-fragments */
// A developer needs to create various content fragments depending on some dynamic names by writing Java code. Which code should be used to create a new content fragment?$code$,
  'java',
  $stem$A developer needs to create various content fragments depending on some dynamic names by writing Java code. Which code should be used to create a new content fragment?$stem$,
  '[{"text": "FragmentTemplate.createFragment()"}, {"text": "resource.createFragment"}, {"text": "adaptTo(Fragment.class)"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: FragmentTemplate.createFragment().$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: FragmentTemplate.createFragment().$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','core-components'], 'behavior prediction',
  $code$/* AEM · core-components */
// A developer has requirement to add a new custom tab to the page properties of a specific page. The sling:resourceType of the page is foo/components/page and the sling:resourceSuperType of that page is core/wcm/components/page/v2/page. What is the best approach$code$,
  'java',
  $stem$A developer has requirement to add a new custom tab to the page properties of a specific page. The sling:resourceType of the page is foo/components/page and the sling:resourceSuperType of that page is core/wcm/components/page/v2/page. What is the best approach?$stem$,
  '[{"text": "1. Copy the cq:dialog from app/core/wcm/components/page/v2/page to app/foo/components/page 2. Remove all the tabs 3. Add the custom tab"}, {"text": "1. Create a new cq:dialog node under app/foo/components/page 2. Add the nodes cq:dialog > content > items 3. Add the custom tab after that node"}, {"text": "1. Identify the location of the cq:dialog node from app/core/wcm/components/page/v2/page 2. Identify the last entry of items node 3. Add the custom tab after that node"}, {"text": "1. Copy the cq:dialog from app/core/wcm/components/page/v2/page to app/foo/components/page 2. Identify the last entry of items node 3. Add the custom tab after that node"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: 1. Copy the cq:dialog from app/core/wcm/components/page/v2/page to app/foo/components/page 2. Remove all the tabs 3. Add the custom tab.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 1. Copy the cq:dialog from app/core/wcm/components/page/v2/page to app/foo/components/page 2. Remove all the tabs 3. Add the custom tab.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// A customer is having trouble with some search queries and provides the following information: The logs show the following warring occurs many times: *WARN* Traversed 1000 nodes with filter Filter (query = SELECt ..) The Client has more than 100000 stored in th$code$,
  'java',
  $stem$A customer is having trouble with some search queries and provides the following information: The logs show the following warring occurs many times: *WARN* Traversed 1000 nodes with filter Filter (query = SELECt ..) The Client has more than 100000 stored in their AEM instance The client uses a custom page property to help search for pages of a given type What should the AEM Developer do to help resolve the clients issue?$stem$,
  '[{"text": "Create a custom oak index for the custom page property"}, {"text": "Set the reindex flag to true for node ''oak:index/cqPageLucene''"}, {"text": "Advise the client to recognize their content by having nodes of no more than 10000 sub nodes."}, {"text": "Use the Index Manager to validate the ''cqPageLucene'' index is enabled"}]'::jsonb,
  0,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: Create a custom oak index for the custom page property.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Create a custom oak index for the custom page property.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','packages'], 'behavior prediction',
  $code$/* AEM · osgi */
// While doing an in-place AEM upgrade, the developer observes an issue in the server logs where all are active excepts for the ACS Commons bundle which is incompatible due to old versions. What should the developer do to resolve this issue?$code$,
  'java',
  $stem$While doing an in-place AEM upgrade, the developer observes an issue in the server logs where all are active excepts for the ACS Commons bundle which is incompatible due to old versions. What should the developer do to resolve this issue?$stem$,
  '[{"text": "Drop the new package uder path crx-quickstart/install and restart"}, {"text": "Install the new jar using the package manager on the old environment"}, {"text": "Update the plugin in pom.xml"}, {"text": "Ask to Admin credentials & install the new bundle in Felix console"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Update the plugin in pom.xml.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Update the plugin in pom.xml.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'hard', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// Select * from [nt:base] as s where s.status=some value What should be the property of index. (choose two)$code$,
  'java',
  $stem$Select * from [nt:base] as s where s.status=some value What should be the property of index. (choose two)$stem$,
  '[{"text": "Status node with propertyIndex value as true"}, {"text": "Index Rule"}, {"text": "Status node with propertyIndex value as false"}, {"text": "Aggregates"}]'::jsonb,
  1,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: Index Rule. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Index Rule.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','content-fragments'], 'behavior prediction',
  $code$/* AEM · content-fragments */
// While configuring Content Fragment Component author has selected Display Mode as Single Text element . This enables the selection of one Multi-Line text element and enables paragraph control options. Which two properties will now determine the resulting paragr$code$,
  'java',
  $stem$While configuring Content Fragment Component author has selected Display Mode as Single Text element . This enables the selection of one Multi-Line text element and enables paragraph control options. Which two properties will now determine the resulting paragraph system?(choose two)$stem$,
  '[{"text": "Paragraph range"}, {"text": "Paragraph title/paragraph heading"}, {"text": "Paragraph scope"}, {"text": "Paragraph description"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Paragraph description. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Paragraph description.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// What is the file store used for Networking File Storage(NFS)?$code$,
  'java',
  $stem$What is the file store used for Networking File Storage(NFS)?$stem$,
  '[{"text": "S3 Data Storage"}, {"text": "Content Repository"}, {"text": "File Data Store"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: File Data Store.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: File Data Store.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// What should be the resourceType node for osgi configuration node in the repository?$code$,
  'java',
  $stem$What should be the resourceType node for osgi configuration node in the repository?$stem$,
  '[{"text": "jcr:osgiConfig"}, {"text": "sling:osgiConfig"}, {"text": "crx:osgiConfig"}]'::jsonb,
  1,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: sling:osgiConfig.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: sling:osgiConfig.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// The SAML 2.0 Authentication Handler is disabled by default. You must set at least one of the following properties in order to enable the handler? (Choose two)$code$,
  'java',
  $stem$The SAML 2.0 Authentication Handler is disabled by default. You must set at least one of the following properties in order to enable the handler? (Choose two)$stem$,
  '[{"text": "The Service Provider Entity ID"}, {"text": "Path"}, {"text": "The Identity Provider POST URL"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: The Identity Provider POST URL. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: The Identity Provider POST URL.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// A developer Wants to send a SAML Authentication request to a specific url of a system entity that creates , manages and updates identity information. Which property of SAML Authentication Handler configuration must be configured with this url?$code$,
  'java',
  $stem$A developer Wants to send a SAML Authentication request to a specific url of a system entity that creates , manages and updates identity information. Which property of SAML Authentication Handler configuration must be configured with this url?$stem$,
  '[{"text": "Identity provider url"}, {"text": "Path"}, {"text": "Default Redirect"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Identity provider url.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Identity provider url.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Which of the following is included in the Service Pack release Notes? (Choose two)$code$,
  'java',
  $stem$Which of the following is included in the Service Pack release Notes? (Choose two)$stem$,
  '[{"text": "Jar file download link"}, {"text": "Known Issues"}, {"text": "Deprecated features"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Deprecated features. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Deprecated features.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Which offload related service is used by each aem instance to connect with aem topology connector?$code$,
  'java',
  $stem$Which offload related service is used by each aem instance to connect with aem topology connector?$stem$,
  '[{"text": "Topology connector service"}, {"text": "Cluster service"}, {"text": "Discovery service"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Discovery service.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Discovery service.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Source and brand are added in the ignoreParamUrl. So which url will be passed? / ignoreParamUrl {{ / glob "*" / type "deny" } { /glob "source" / type "allow" } { /glob "brand" / type "allow" } }$code$,
  'java',
  $stem$Source and brand are added in the ignoreParamUrl. So which url will be passed? / ignoreParamUrl {{ / glob "*" / type "deny" } { /glob "source" / type "allow" } { /glob "brand" / type "allow" } }$stem$,
  '[{"text": "url?source=value&brand=value2&param=value3"}, {"text": "url?source=value"}, {"text": "url?source=value&param=value3"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: url?source=value&brand=value2&param=value3.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: url?source=value&brand=value2&param=value3.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages'], 'behavior prediction',
  $code$/* AEM · packages */
// What is packageType for immutable code packages in maven project?$code$,
  'java',
  $stem$What is packageType for immutable code packages in maven project?$stem$,
  '[{"text": "<packageType>application</packageType>"}, {"text": "<packageType>content</packageType>"}, {"text": "<packageType>container</packageType>"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: <packageType>application</packageType>.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: <packageType>application</packageType>.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','cloud-service','core-components'], 'behavior prediction',
  $code$/* AEM · cloud-service */
// A developer need to use AEM core components in prod without need to download and install core component. Which aem version would be use ?$code$,
  'java',
  $stem$A developer need to use AEM core components in prod without need to download and install core component. Which aem version would be use ?$stem$,
  '[{"text": "AEM as Cloud Service"}, {"text": "Version 6.3"}, {"text": "Adobe managed services"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: AEM as Cloud Service.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: AEM as Cloud Service.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A developer needs to remove selectors from this url 'path/page.woo.foo.html' so what should be the syntax? (choose two)$code$,
  'java',
  $stem$A developer needs to remove selectors from this url 'path/page.woo.foo.html' so what should be the syntax? (choose two)$stem$,
  '[{"text": "${ ''path/page.woo.foo.html'' @removeSelectors[foo,bar]}"}, {"text": "${ ''path/page.woo.foo.html'' @removeSelectors{foo,bar,woo}}"}, {"text": "${ ''path/page.woo.foo.html'' @selectors=}"}, {"text": "${ ''path/page.woo.foo.html'' @selectors}"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: ${ 'path/page.woo.foo.html' @selectors}. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: ${ 'path/page.woo.foo.html' @selectors}.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A content author will use live copies on aem. Which 2 factors he need to consider?$code$,
  'java',
  $stem$A content author will use live copies on aem. Which 2 factors he need to consider?$stem$,
  '[{"text": "Changes done locally to a component which is marked as container will not be overwritten"}, {"text": "When reverting a canceled inheritance on a paragraph system the order of components will be changed"}, {"text": "When inheritance is re-enabled, page is auto sync with source"}, {"text": "If component is marked as container, cancellation and suspend actions dont apply for child comp"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: If component is marked as container, cancellation and suspend actions dont apply for child comp.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: If component is marked as container, cancellation and suspend actions dont apply for child comp.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','experience-fragments'], 'behavior prediction',
  $code$/* AEM · experience-fragments */
// While exporting the Experience Fragment to json what selector should be used?$code$,
  'java',
  $stem$While exporting the Experience Fragment to json what selector should be used?$stem$,
  '[{"text": "plain"}, {"text": "text"}, {"text": "nocss"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: nocss.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: nocss.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages'], 'behavior prediction',
  $code$/* AEM · packages */
// Which property of maven is used to build an aem project with specific version ?$code$,
  'java',
  $stem$Which property of maven is used to build an aem project with specific version ?$stem$,
  '[{"text": "<packageVersion>"}, {"text": "<version>"}, {"text": "<aemVersion>"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: <version>.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: <version>.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','experience-fragments'], 'behavior prediction',
  $code$/* AEM · experience-fragments */
// A Developer need to export Experience Fragment to adobe Target then what should be the format for exported experience fragment?$code$,
  'java',
  $stem$A Developer need to export Experience Fragment to adobe Target then what should be the format for exported experience fragment?$stem$,
  '[{"text": "HTML"}, {"text": "XML"}, {"text": "JSON"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: HTML.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: HTML.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Where we can define global properties for the project?$code$,
  'java',
  $stem$Where we can define global properties for the project?$stem$,
  '[{"text": "<properties></properties> in parent pom"}, {"text": "<properties></properties> in core pom"}, {"text": "<properties></properties> in all module"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: <properties></properties> in parent pom.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: <properties></properties> in parent pom.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','archetype'], 'behavior prediction',
  $code$/* AEM · osgi */
// To overwrite OSGi Configurations where a developer must write the code in codebase?$code$,
  'java',
  $stem$To overwrite OSGi Configurations where a developer must write the code in codebase?$stem$,
  '[{"text": "Ui.content"}, {"text": "Ui.apps"}, {"text": "Core"}]'::jsonb,
  1,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: Ui.apps.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Ui.apps.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// A developer wants to create a index with multiple properties and it needs to be updated asynchronously.$code$,
  'java',
  $stem$A developer wants to create a index with multiple properties and it needs to be updated asynchronously.$stem$,
  '[{"text": "Property"}, {"text": "Ordered"}, {"text": "Lucene"}]'::jsonb,
  2,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: Lucene.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Lucene.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// What should we set for debug log for SAML?$code$,
  'java',
  $stem$What should we set for debug log for SAML?$stem$,
  '[{"text": "com.adobe.granite.auth.saml"}, {"text": "com.adobe.sling.auth.saml"}, {"text": "com.adobe.granite.debug.auth.saml"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: com.adobe.granite.auth.saml.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: com.adobe.granite.auth.saml.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','msm'], 'behavior prediction',
  $code$/* AEM · msm */
// Author wants to define blueprint configuration to identify existing website that will be used as source for other pages. Which 2 rules must content author follow ?$code$,
  'java',
  $stem$Author wants to define blueprint configuration to identify existing website that will be used as source for other pages. Which 2 rules must content author follow ?$stem$,
  '[{"text": "The root of each language has at least 2 child pages"}, {"text": "Immediate child page of root are language branches of website."}, {"text": "The website should have a single page as root"}, {"text": "Each language page must have a country child page"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: The website should have a single page as root.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: The website should have a single page as root.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// What will you see at maintenance screen on this : http://localhost:4502/libs/granite/operations/content/maintenance.html$code$,
  'java',
  $stem$What will you see at maintenance screen on this : http://localhost:4502/libs/granite/operations/content/maintenance.html$stem$,
  '[{"text": "Quarterly"}, {"text": "Daily"}, {"text": "Monthly"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Daily.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Daily.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// A developer is starting an aem instance every time in the debug mode by providing JVM parameter in the console. The author needs to automate this process to avoid adding JVM parameters at every start of an AEM instance. How would developer achieve this goal?$code$,
  'java',
  $stem$A developer is starting an aem instance every time in the debug mode by providing JVM parameter in the console. The author needs to automate this process to avoid adding JVM parameters at every start of an AEM instance. How would developer achieve this goal?$stem$,
  '[{"text": "By adding JVM parameters to the start script"}, {"text": "By adding JVM parameters to the [runMode] / crxquikstart/conf/quikstart.properties"}, {"text": "By adding the OSGI Configuration AEM-start to true"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: By adding JVM parameters to the start script.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: By adding JVM parameters to the start script.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','dispatcher'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// Two methods used to update cache?$code$,
  'java',
  $stem$Two methods used to update cache?$stem$,
  '[{"text": "Restart publish instance"}, {"text": "Content update"}, {"text": "Restart author instance"}, {"text": "Auto-invalidation on dispatcher"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Auto-invalidation on dispatcher.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Auto-invalidation on dispatcher.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','dispatcher','cloud-service','replication'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// In AEM, one needs a feature to able to explicitly clear dispatcher resources. Which method is preferred?$code$,
  'java',
  $stem$In AEM, one needs a feature to able to explicitly clear dispatcher resources. Which method is preferred?$stem$,
  '[{"text": "Enable explicit cache invalidation feature in cloud manager"}, {"text": "Create Servlet, which makes HTTP request to dispatcher"}, {"text": "Use Replication API with flush agent"}]'::jsonb,
  2,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: Use Replication API with flush agent.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Use Replication API with flush agent.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// What is the plugin name used to clean the target folder?$code$,
  'java',
  $stem$What is the plugin name used to clean the target folder?$stem$,
  '[{"text": "maven-clean-plugin"}, {"text": "mvn-clean-plugin"}, {"text": "clean-plugin"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: maven-clean-plugin.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: maven-clean-plugin.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','dispatcher'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// What will be the default response of dispatcher if it is deny for some url in /filter property?$code$,
  'java',
  $stem$What will be the default response of dispatcher if it is deny for some url in /filter property?$stem$,
  '[{"text": "400"}, {"text": "404"}, {"text": "403"}]'::jsonb,
  2,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: 403.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 403.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','security'], 'behavior prediction',
  $code$/* AEM · osgi */
// Which of the following two configuration will be applied when the instance will be started having runmodes author,dev,emea?$code$,
  'java',
  $stem$Which of the following two configuration will be applied when the instance will be started having runmodes author,dev,emea?$stem$,
  '[{"text": "/apps/*/config.author.dev.emea.ldap"}, {"text": "/apps/*/config.publish"}, {"text": "/apps/*/config.author.emea.dev"}, {"text": "/apps/*/config.author"}]'::jsonb,
  3,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: /apps/*/config.author.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: /apps/*/config.author.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Which service is used in aem to control how its instance interact with topology while running?$code$,
  'java',
  $stem$Which service is used in aem to control how its instance interact with topology while running?$stem$,
  '[{"text": "Offloading Service"}, {"text": "Web console Service"}, {"text": "Placeholder answer since Platform does not support 2 answers"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Offloading Service.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Offloading Service.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','cloud-service'], 'behavior prediction',
  $code$/* AEM · cloud-service */
// A developer is working on AEM as cloud so what is the Golden Master?$code$,
  'java',
  $stem$A developer is working on AEM as cloud so what is the Golden Master?$stem$,
  '[{"text": "Publish node"}, {"text": "Content Repository"}, {"text": "Cloud Manager with github repo"}, {"text": "Author node"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Cloud Manager with github repo.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Cloud Manager with github repo.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'easy', ARRAY['aem','dispatcher','testing','replication'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// Which URI should be used to configure a flush agent for port 80 on a local testing server?$code$,
  'java',
  $stem$Which URI should be used to configure a flush agent for port 80 on a local testing server?$stem$,
  '[{"text": "//localhost:80/dispatcher/validate.flush"}, {"text": "//localhost:80/dispatcher/invalidate.cache"}, {"text": "//localhost:80/dispatcher/validate.cache"}, {"text": "//localhost:80/dispatcher/invalidate.flush"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: //localhost:80/dispatcher/invalidate.cache.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: //localhost:80/dispatcher/invalidate.cache.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','osgi','security'], 'behavior prediction',
  $code$/* AEM · osgi */
// An instance of AEM has been upgraded from 5.6 to 6.0 and then 6.5. Which three OSGi configurations are needed to integrate LDAP with this upgraded instance of AEM? (Choose three.)$code$,
  'java',
  $stem$An instance of AEM has been upgraded from 5.6 to 6.0 and then 6.5. Which three OSGi configurations are needed to integrate LDAP with this upgraded instance of AEM? (Choose three.)$stem$,
  '[{"text": "Authentication Handler"}, {"text": "SSL Certificate"}, {"text": "LDAP IDP"}, {"text": "Sync Handler"}, {"text": "External Login Module"}]'::jsonb,
  4,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: External Login Module.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: External Login Module.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// A developer must create a workflow step that assigns a 'WorkItem' to the appropriate person based on who has the least amount work to do. The group that must perform the action is configured into the workflow. Which non-deprecated interface should the Java imp$code$,
  'java',
  $stem$A developer must create a workflow step that assigns a 'WorkItem' to the appropriate person based on who has the least amount work to do. The group that must perform the action is configured into the workflow. Which non-deprecated interface should the Java implementation class use to perform the assignment?$stem$,
  '[{"text": "com.adobe.granite.workflow.exec.ParticipantStepChooser"}, {"text": "com.day.cq.workflow.exec.ParticipantChooser"}, {"text": "com.day.cq.workflow.exec.WorkItem"}, {"text": "com.adobe.granite.workflow.exec.WorkflowData"}]'::jsonb,
  1,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: com.day.cq.workflow.exec.ParticipantChooser.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: com.day.cq.workflow.exec.ParticipantChooser.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// For each CRX node in the hierarchy, which actions can be configured using the user admin interface?$code$,
  'java',
  $stem$For each CRX node in the hierarchy, which actions can be configured using the user admin interface?$stem$,
  '[{"text": "Read, Modify, Create, Delete, Read ACL, Edit ACL, Replicate"}, {"text": "Read, Modify, Create, Delete, Read ACL, Edit ACL"}, {"text": "Read, Write, Read ACL, Edit ACL, Replicate"}, {"text": "Read, Write, Delete, Edit ACL, Replicate"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Read, Modify, Create, Delete, Read ACL, Edit ACL, Replicate.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Read, Modify, Create, Delete, Read ACL, Edit ACL, Replicate.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// A development team wants to use the recommended language for the Oak query engine. This team wants to also avoid using the deprecated language for the Oak query engine and cannot use JQOM for the current project. Which languages should be used? Choose two answ$code$,
  'java',
  $stem$A development team wants to use the recommended language for the Oak query engine. This team wants to also avoid using the deprecated language for the Oak query engine and cannot use JQOM for the current project. Which languages should be used? Choose two answers.$stem$,
  '[{"text": "XPath"}, {"text": "SQL"}, {"text": "XML"}, {"text": "SQL-2"}]'::jsonb,
  3,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: SQL-2. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: SQL-2.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages'], 'behavior prediction',
  $code$/* AEM · packages */
// A developer is installing a content package with the package manager. The developer needs to restrict the approximate number of nodes in a batch that is saved to persistent storage in one transaction. How should the developer modify the number of transient nod$code$,
  'java',
  $stem$A developer is installing a content package with the package manager. The developer needs to restrict the approximate number of nodes in a batch that is saved to persistent storage in one transaction. How should the developer modify the number of transient nodes to be triggered until automatic saving?$stem$,
  '[{"text": "Select the option MergePreserve for the Access Control Handling drop-down in the Install Package dialog-box"}, {"text": "Modify the export package manifest header and copy the content package to AEM installation folder"}, {"text": "Change the value of Save Threshold in the Install Package dialog-box"}, {"text": "AEM instances automatically modify the number of transient nodes based on the load balancing"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Select the option MergePreserve for the Access Control Handling drop-down in the Install Package dialog-box.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Select the option MergePreserve for the Access Control Handling drop-down in the Install Package dialog-box.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','core-components'], 'behavior prediction',
  $code$/* AEM · core-components */
// A developer wants to extend AEM Core Components to create a custom Carousel Component. How should the developer extend the Core Components?$code$,
  'java',
  $stem$A developer wants to extend AEM Core Components to create a custom Carousel Component. How should the developer extend the Core Components?$stem$,
  '[{"text": "Copy the Core Carousel component to /apps/ folder"}, {"text": "Use the sling:resourceType property to point to the core component"}, {"text": "Use the sling:resourceSuperType property to point to the core component"}, {"text": "Make changes to the original component and assign a component group"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Copy the Core Carousel component to /apps/ folder.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Copy the Core Carousel component to /apps/ folder.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// In an instance of AEM, queries with full-text conditions are not working as expected. A developer creates a new node under oak:index and names the node LucenedIndex. Which properties and values need to be added to this node to make the node a full text index? $code$,
  'java',
  $stem$In an instance of AEM, queries with full-text conditions are not working as expected. A developer creates a new node under oak:index and names the node LucenedIndex. Which properties and values need to be added to this node to make the node a full text index? (Choose two answers.)$stem$,
  '[{"text": "async: async"}, {"text": "includePropertyNames: [full]"}, {"text": "type: lucene"}, {"text": "reindex: true"}]'::jsonb,
  2,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: type: lucene. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: type: lucene.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// When configuring a logger for SAML, which value is needed for the Logger property?$code$,
  'java',
  $stem$When configuring a logger for SAML, which value is needed for the Logger property?$stem$,
  '[{"text": "logs/saml.log"}, {"text": "Debug"}, {"text": "com.adobe.sling.auth.saml"}, {"text": "com.adobe.granite.auth.saml"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: com.adobe.granite.auth.saml.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: com.adobe.granite.auth.saml.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// An AEM website needs its content delivered as JSON with headless endpoints. Which two characteristics of development fit under the mold of a headless model for development? (Choose two.)$code$,
  'java',
  $stem$An AEM website needs its content delivered as JSON with headless endpoints. Which two characteristics of development fit under the mold of a headless model for development? (Choose two.)$stem$,
  '[{"text": "Content is delivered via AEM Components"}, {"text": "Styling happens outside the AEM platform"}, {"text": "SPAs can be a destination for AEM content"}, {"text": "Content is only delivered through HTML files"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: SPAs can be a destination for AEM content. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: SPAs can be a destination for AEM content.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak','content-fragments'], 'behavior prediction',
  $code$/* AEM · oak */
// A developer is using GraphQL to deliver a content fragment. The developer needs the missing piece to the code to retrieve the listed items in JSON format. Which word is needed for the missing code? { personList { items { _path firstName lastName title } } }$code$,
  'java',
  $stem$A developer is using GraphQL to deliver a content fragment. The developer needs the missing piece to the code to retrieve the listed items in JSON format. Which word is needed for the missing code? { personList { items { _path firstName lastName title } } }$stem$,
  '[{"text": "call"}, {"text": "get"}, {"text": "query"}, {"text": "retrieve"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: query.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: query.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','testing'], 'behavior prediction',
  $code$/* AEM · testing */
// A developer has the BylinelmplTest.java file open and needs to create an AEM context for setting up a test involving mock data. Which line of code should be added above the code to declare the BylinelmpTest class?$code$,
  'java',
  $stem$A developer has the BylinelmplTest.java file open and needs to create an AEM context for setting up a test involving mock data. Which line of code should be added above the code to declare the BylinelmpTest class?$stem$,
  '[{"text": "@ExtendWith(AemContent.class)"}, {"text": "@ExtendWith(AemContext.class)"}, {"text": "@ExtendWith(AemContextExtension.class)"}, {"text": "@ExtendWith(AemExtension.class)"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: @ExtendWith(AemContextExtension.class).$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: @ExtendWith(AemContextExtension.class).$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// An AEM implementation, version 6 has custom Login Modules. A group wants to upgrade the implementation to 6.5. What needs to be done with the custom login modules?$code$,
  'java',
  $stem$An AEM implementation, version 6 has custom Login Modules. A group wants to upgrade the implementation to 6.5. What needs to be done with the custom login modules?$stem$,
  '[{"text": "The custom modules need to be deleted and then recreated after the upgrade"}, {"text": "The LoginModule parameter needs to be added to the custom module"}, {"text": "Nothing"}, {"text": "The custom modules need to be disabled and then recreated after the upgrade"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Nothing.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Nothing.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','dispatcher'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// When setting up filters for an AEM instance, which should be the first filter in the dispatcher.any file if best practices are followed?$code$,
  'java',
  $stem$When setting up filters for an AEM instance, which should be the first filter in the dispatcher.any file if best practices are followed?$stem$,
  '[{"text": "{ /type \"deny\" /all \"*\" }"}, {"text": "{ /type \"allow\" /glob \"*\" }"}, {"text": "{ /type \"allow\" /all \"*\" }"}, {"text": "{ /type \"deny\" /glob \"*\" }"}]'::jsonb,
  3,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: { /type "deny" /glob "*" }.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: { /type "deny" /glob "*" }.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','spa','testing'], 'behavior prediction',
  $code$/* AEM · spa */
// A developer wants to write and run UI tests directly in a web browser. Which testing library should the developer use?$code$,
  'java',
  $stem$A developer wants to write and run UI tests directly in a web browser. Which testing library should the developer use?$stem$,
  '[{"text": "React.js"}, {"text": "Angular.js"}, {"text": "Hobbes.js"}, {"text": "Bobcat,js"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Hobbes.js.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Hobbes.js.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','workflow','clientlibs'], 'behavior prediction',
  $code$/* AEM · osgi */
// Which front-end development workflow tool allows a developer to style and develop a site based on static output of AEM webpages within the ui.frontend module?$code$,
  'java',
  $stem$Which front-end development workflow tool allows a developer to style and develop a site based on static output of AEM webpages within the ui.frontend module?$stem$,
  '[{"text": "Client Library Generation"}, {"text": "Storybook"}, {"text": "Webpack Static Development Server"}, {"text": "OSGi Services"}]'::jsonb,
  2,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: Webpack Static Development Server.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Webpack Static Development Server.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','htl'], 'behavior prediction',
  $code$/* AEM · htl */
// A developer needs to create a new component called Component A. Component A must show a list of other components that all have a resource type of existing Component B. Component A must render this list of tiles for each Component B where the tile rendering is $code$,
  'java',
  $stem$A developer needs to create a new component called Component A. Component A must show a list of other components that all have a resource type of existing Component B. Component A must render this list of tiles for each Component B where the tile rendering is different from the default one. The list of rendered tiles must be reusable by future new components. How should the developer implement this functionality?$stem$,
  '[{"text": "Component A overlays Component B and overwrites the base renderer to facilitate the tiles"}, {"text": "Component A calls the HTL of Component B directly using a data-sly-include attribute"}, {"text": "Component A inherits from Component B and overwrites the base renderer to facilitate the tiles"}, {"text": "Create a script for tile rendering in Component B and use data-sly-resource attribute with a Sling selector in Component A to render the tile"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Create a script for tile rendering in Component B and use data-sly-resource attribute with a Sling selector in Component A to render the tile.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Create a script for tile rendering in Component B and use data-sly-resource attribute with a Sling selector in Component A to render the til.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// A developer wants to change the log level for a custom API. Which OSGi configuration should the developer modify?$code$,
  'java',
  $stem$A developer wants to change the log level for a custom API. Which OSGi configuration should the developer modify?$stem$,
  '[{"text": "Apache Sling Log Tracker Service"}, {"text": "Apache Sling Logging Writer Configuration"}, {"text": "Apache Sling Logging Configuration"}, {"text": "Adobe Granite Log Analysis Service"}]'::jsonb,
  2,
  $exp$OSGi configuration in AEM follows run-mode folders and PID files under /apps; the matching answer is: Apache Sling Logging Configuration.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Apache Sling Logging Configuration.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','spa'], 'behavior prediction',
  $code$/* AEM · sling-models */
// A developer needs to map a React image component to a corresponding AEM image component. What code should the developer use?$code$,
  'java',
  $stem$A developer needs to map a React image component to a corresponding AEM image component. What code should the developer use?$stem$,
  '[{"text": "RefTo(''wknd-spa-react/components/image)(Image, ImageEditConfig);"}, {"text": "MapTo(''wknd-spa-react/components/image'')(Image, ImageEditConfig):"}, {"text": "MapTo(Image, ImageEditConfig)(wknd-spa-react/components/image);"}, {"text": "RefTo(Image, ImageEditConfig)(''wknd-spa-react/components/image);"}]'::jsonb,
  1,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: MapTo('wknd-spa-react/components/image')(Image, ImageEditConfig):.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: MapTo('wknd-spa-react/components/image')(Image, ImageEditConfig):.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem','sling-models','dispatcher'], 'behavior prediction',
  $code$/* AEM · sling-models */
// Which file is the default file to store the Dispatcher configuration?$code$,
  'java',
  $stem$Which file is the default file to store the Dispatcher configuration?$stem$,
  '[{"text": "dispatcher.yaml"}, {"text": "dispatcher.any"}, {"text": "dispatcher.xml"}, {"text": "dispatcher.config"}]'::jsonb,
  1,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: dispatcher.any.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: dispatcher.any.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','spa','testing'], 'behavior prediction',
  $code$/* AEM · spa */
// An instance of AEM has been upgraded to version 6.5. With that upgrade, which testing framework is being recommended as the testing framework for that version and beyond?$code$,
  'java',
  $stem$An instance of AEM has been upgraded to version 6.5. With that upgrade, which testing framework is being recommended as the testing framework for that version and beyond?$stem$,
  '[{"text": "Selenium automation"}, {"text": "Bobcat.js"}, {"text": "Mocha,js"}, {"text": "React.js"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: React.js.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: React.js.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi','packages'], 'behavior prediction',
  $code$/* AEM · osgi */
// A custom AEM application contains Bundle A and Bundle B. Bundle A has a dependency to Bundle B via Import-Package. How can both bundles be deployed most efficiently across all environments?$code$,
  'java',
  $stem$A custom AEM application contains Bundle A and Bundle B. Bundle A has a dependency to Bundle B via Import-Package. How can both bundles be deployed most efficiently across all environments?$stem$,
  '[{"text": "Use the Felix Web Console to upload the bundles in the correct order"}, {"text": "Create one content package per bundle and use a package dependency to ensure installation order"}, {"text": "Embed both bundles in one content package and use property ''installationOrder'' in package properties for correct bundle installation order"}, {"text": "Embed both bundles in one content package: the dependency via Import-Package is enough to ensure correct installation"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Embed both bundles in one content package: the dependency via Import-Package is enough to ensure correct installation.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Embed both bundles in one content package: the dependency via Import-Package is enough to ensure correct installation.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A new AEM developer is trying to display a page heading and needs to know the proper syntax for accessing the property of a variable as there this method will be used to ultimately display several page elements. Which two code examples show the correct syntax $code$,
  'java',
  $stem$A new AEM developer is trying to display a page heading and needs to know the proper syntax for accessing the property of a variable as there this method will be used to ultimately display several page elements. Which two code examples show the correct syntax for accessing a property of a variable in AEM? (Choose two.)$stem$,
  '[{"text": "${page[''heading'']}"}, {"text": "${page.heading}"}, {"text": "${page{''heading''}}"}, {"text": "${page[heading]}"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: ${page.heading}. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: ${page.heading}.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','osgi'], 'behavior prediction',
  $code$/* AEM · osgi */
// From which AEM Web Console should a developer access and download full AEM Log Files?$code$,
  'java',
  $stem$From which AEM Web Console should a developer access and download full AEM Log Files?$stem$,
  '[{"text": "Web Console -> System Information"}, {"text": "AEM -> Log files"}, {"text": "Status -> Log files"}, {"text": "OSGI -> Sing Log Service"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: OSGI -> Sing Log Service.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: OSGI -> Sing Log Service.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','spa'], 'behavior prediction',
  $code$/* AEM · spa */
// A developer is viewing this JSON code for a text component in AEM: { "text" : "<p>Sample text</p>" , "richText" : true , "type" : "core/wcm/components/text/v2/text" } Which property value is used to map a SPA component to an AEM component?$code$,
  'java',
  $stem$A developer is viewing this JSON code for a text component in AEM: { "text" : "<p>Sample text</p>" , "richText" : true , "type" : "core/wcm/components/text/v2/text" } Which property value is used to map a SPA component to an AEM component?$stem$,
  '[{"text": "richText"}, {"text": ":spa"}, {"text": ":type"}, {"text": "Text"}]'::jsonb,
  2,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: :type.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: :type.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Which log file we must check for the response for each request together related to AEM instance?$code$,
  'java',
  $stem$Which log file we must check for the response for each request together related to AEM instance?$stem$,
  '[{"text": "Stout log"}, {"text": "Debug log"}, {"text": "Request Log"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Request Log.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Request Log.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','spa'], 'behavior prediction',
  $code$/* AEM · spa */
// A developer has built a SPA in React and needs to get it ready for a migration to AEM. Which tasks does the developer need to perform to get the SPA ready for the migration? (Choose three.)$code$,
  'java',
  $stem$A developer has built a SPA in React and needs to get it ready for a migration to AEM. Which tasks does the developer need to perform to get the SPA ready for the migration? (Choose three.)$stem$,
  '[{"text": "Use the AEM SDK containers to place components on the screen"}, {"text": "Create an AEM component for each JS component"}, {"text": "Make their JS components modular"}, {"text": "Agree on components and their JSON model"}, {"text": "Implement each component''s render() method"}]'::jsonb,
  2,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: Make their JS components modular.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Make their JS components modular.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','editable-templates'], 'behavior prediction',
  $code$/* AEM · editable-templates */
// The structure section of an editable template has a locked component. What happens to the content of that component when a developer unlocks it?$code$,
  'java',
  $stem$The structure section of an editable template has a locked component. What happens to the content of that component when a developer unlocks it?$stem$,
  '[{"text": "The content is copied to the initial section of the editable template."}, {"text": "The content is deleted after confirmation from the template author."}, {"text": "The content is moved to the initial section of the editable template"}, {"text": "The content stays in the same place but it ignored on pages using the template"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: The content is moved to the initial section of the editable template.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: The content is moved to the initial section of the editable template.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','clientlibs','core-components','editable-templates'], 'behavior prediction',
  $code$/* AEM · clientlibs */
// A developer creates Editable Templates based on a custom Page component. The developer wants to leverage the Style System within the Editable Templates to allow authors to switch between the Dark and Light Theme. The Style System dialog is NOT enabled for the $code$,
  'java',
  $stem$A developer creates Editable Templates based on a custom Page component. The developer wants to leverage the Style System within the Editable Templates to allow authors to switch between the Dark and Light Theme. The Style System dialog is NOT enabled for the site. What should the developer do to resolve this issue?$stem$,
  '[{"text": "Create two new client libraries with a dark and light theme and map them to the Page component."}, {"text": "Set the sling:resourceSuperType property to core/wcm/components/page/v2/page on the Page component."}, {"text": "Create a new dialog for the custom Page components"}, {"text": "Define Style Definitions using Page Policy dialog on Editable Template"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Create two new client libraries with a dark and light theme and map them to the Page component..$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Create two new client libraries with a dark and light theme and map them to the Page component..$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','spa'], 'behavior prediction',
  $code$/* AEM · sling-models */
// Frontend developer working on an aem SPA is not able to see property that should be exposed in component added to page. Which option would give information if required property is exposed by sling model?$code$,
  'java',
  $stem$Frontend developer working on an aem SPA is not able to see property that should be exposed in component added to page. Which option would give information if required property is exposed by sling model?$stem$,
  '[{"text": "[homepage-path]/sling.json"}, {"text": "[homepage-path]/sling-model.json"}, {"text": "[homepage-path]/model.json"}]'::jsonb,
  2,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: [homepage-path]/model.json.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: [homepage-path]/model.json.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','dispatcher','replication'], 'behavior prediction',
  $code$/* AEM · dispatcher */
// An AEM administrator navigates to the Reports area in an AEM instance. The administrator wants to know how long it is taking people to reach the AEM or Dispatcher port and wants to be able to do so for both Author and Publish instances. In the System Monitorin$code$,
  'java',
  $stem$An AEM administrator navigates to the Reports area in an AEM instance. The administrator wants to know how long it is taking people to reach the AEM or Dispatcher port and wants to be able to do so for both Author and Publish instances. In the System Monitoring area of AEM, which metric represents the response time to access the AEM or Dispatcher port?$stem$,
  '[{"text": "Port Bandwidth"}, {"text": "Port Speed"}, {"text": "Replication Agent"}, {"text": "CQ Port Check"}]'::jsonb,
  3,
  $exp$Dispatcher domain/routing is handled in Apache vhost (and related dispatcher) config. Correct: CQ Port Check.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: CQ Port Check.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','security'], 'behavior prediction',
  $code$/* AEM · security */
// Users have requested on an AEM-based website to have the ability to sign in to the site using their social media accounts. Which authentication handler must be enabled to accomplish this task?$code$,
  'java',
  $stem$Users have requested on an AEM-based website to have the ability to sign in to the site using their social media accounts. Which authentication handler must be enabled to accomplish this task?$stem$,
  '[{"text": "Adobe Granite SSO Authentication Handler"}, {"text": "Adobe Granite OAuth Authentication Handler"}, {"text": "AEM Communities Social OAuth Provider"}, {"text": "AEM Platform Authentication Hander"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Adobe Granite OAuth Authentication Handler.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Adobe Granite OAuth Authentication Handler.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// A business wants to save time when doing an in-place upgrade of an AEM instance. To meet this requirement, when should Oak indexes be reindexed in relation to the upgrade itself?$code$,
  'java',
  $stem$A business wants to save time when doing an in-place upgrade of an AEM instance. To meet this requirement, when should Oak indexes be reindexed in relation to the upgrade itself?$stem$,
  '[{"text": "Before"}, {"text": "During"}, {"text": "After"}, {"text": "The indexes should be rebuilt instead of upgraded"}]'::jsonb,
  0,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: Before.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Before.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// An AEM developer wants to build a Generic Snippet to create a new service. Which word goes in the missing parts of the code block to complete this action? ( function () { var ga = document . createElement ( "_____" ); ga . type = 'text/javascript' ; ga . async$code$,
  'java',
  $stem$An AEM developer wants to build a Generic Snippet to create a new service. Which word goes in the missing parts of the code block to complete this action? ( function () { var ga = document . createElement ( "_____" ); ga . type = 'text/javascript' ; ga . async = true ; ga . src = ( 'https:' == document . location . protocol ? 'https://ssl' : 'https://www' ) + '.google-analytics.com/ga.s' ; var s = document . getElementsByTagName ( '____' )[ 0 ]; s . parentNode . insertBefore ( ga , s ); })();$stem$,
  '[{"text": "head"}, {"text": "meta"}, {"text": "element"}, {"text": "script"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: script.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: script.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// An AEM developer is attempting to configure the component edit bar and wants to add a button to edit a component and allow annotations to the component. The developer does not have a custom button built for this purpose and wants one button to do both the edit$code$,
  'java',
  $stem$An AEM developer is attempting to configure the component edit bar and wants to add a button to edit a component and allow annotations to the component. The developer does not have a custom button built for this purpose and wants one button to do both the editing and the annotating of the component and its contents. Indicate the correct word or phrase for the missing code piece to complete this task. <jcr:root xmins:cq = "https://www.day.com/jcr/cq/1.0" xmins:jcr = "https://www.jcp.org/jcr/1.0" cq:actions = "[ insert,delete]" cq:layout = "editbar" jcr:primaryType = "cq:EditConfig" />$stem$,
  '[{"text": "edit"}, {"text": "editannoate"}, {"text": "annotate"}, {"text": "edit, annotate"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: editannoate.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: editannoate.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models','htl'], 'behavior prediction',
  $code$/* AEM · sling-models */
// When using a hybrid implementation, which format does the Sling Model Exporter support for rendering Experience Manager content, using custom business logic?$code$,
  'java',
  $stem$When using a hybrid implementation, which format does the Sling Model Exporter support for rendering Experience Manager content, using custom business logic?$stem$,
  '[{"text": "HTL"}, {"text": "JSP"}, {"text": "JSON"}, {"text": "HTML"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: JSON.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: JSON.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A folder was created as a configuration folder for the authoring environment within an instance of AEM. How should this folder be named?$code$,
  'java',
  $stem$A folder was created as a configuration folder for the authoring environment within an instance of AEM. How should this folder be named?$stem$,
  '[{"text": "config.authoring"}, {"text": "config"}, {"text": "config.author"}, {"text": "author.config"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: config.author.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: config.author.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Which log file contains AEM application request and response entries?$code$,
  'java',
  $stem$Which log file contains AEM application request and response entries?$stem$,
  '[{"text": "response.log"}, {"text": "history.log"}, {"text": "request.log"}, {"text": "audit.log"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: request.log.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: request.log.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A team developing components and templates for multiple authoring groups wants to make sure authors from one brand do not see components and template from a different brand. Which two sets of properties should be utilized for ensuring authors only see template$code$,
  'java',
  $stem$A team developing components and templates for multiple authoring groups wants to make sure authors from one brand do not see components and template from a different brand. Which two sets of properties should be utilized for ensuring authors only see templates in their respective brands? (Choose two.)$stem$,
  '[{"text": "allowedPaths"}, {"text": "componentGroup"}, {"text": "vanityURL"}, {"text": "templateGroup"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: componentGroup. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: componentGroup.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// Two development teams are using versions 2.0 and 2.1 of a project library, the latter being a recent upgrade to 2.1. One of the development teams notices the project is now not functioning. What is the best solution for this problem?$code$,
  'java',
  $stem$Two development teams are using versions 2.0 and 2.1 of a project library, the latter being a recent upgrade to 2.1. One of the development teams notices the project is now not functioning. What is the best solution for this problem?$stem$,
  '[{"text": "Make the APIs match in each version of a project"}, {"text": "Break the dependencies between the two projects"}, {"text": "Make the projects children of one parent project"}, {"text": "Declare dependencies across projects"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Make the projects children of one parent project.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Make the projects children of one parent project.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// An AEM Developer is creating a custom component and wants to sort a list of images within the component. The developer also wants to sort list of values later using the same keyword. Which missing word will finish the code block necessary to perform this task?$code$,
  'java',
  $stem$An AEM Developer is creating a custom component and wants to sort a list of images within the component. The developer also wants to sort list of values later using the same keyword. Which missing word will finish the code block necessary to perform this task? The same word goes in both empty slots. public class ImageList implements Image { @ValueMapValue private List < String > images ; @Override public List < String > getlmages () { if ( images != null ) { ______ . sort ( images ); return new ArrayList < String > ( images ); } else { return _______ . emptyList (); } } }$stem$,
  '[{"text": "ArrayList"}, {"text": "Array"}, {"text": "Collections"}, {"text": "Sort"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Collections.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Collections.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// Which two approaches for deploying AEM create an active-active cluster for the AEM author environment? (Choose two.)$code$,
  'java',
  $stem$Which two approaches for deploying AEM create an active-active cluster for the AEM author environment? (Choose two.)$stem$,
  '[{"text": "Oak Cluster with MongoMkK Failover for High Availability in a Single Datacenter"}, {"text": "TarMK Farm"}, {"text": "TarMK Cold Standby"}, {"text": "Oak Cluster with MongoMK Failover Across Multiple Datacenters"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Oak Cluster with MongoMK Failover Across Multiple Datacenters. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Oak Cluster with MongoMK Failover Across Multiple Datacenters.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','htl'], 'behavior prediction',
  $code$/* AEM · htl */
// An AEM developer wants to display a title using HTL if the title exists. The developer may want to add code later to display an element if here are no child pages or base an element display on the existence of a property. The developer needs to know what the m$code$,
  'java',
  $stem$An AEM developer wants to display a title using HTL if the title exists. The developer may want to add code later to display an element if here are no child pages or base an element display on the existence of a property. The developer needs to know what the missing element is in this code, which can be used to satisfy any of the aforementioned conditions, this one to display a title using HTL if the title exists: <h1 ___________ = "${properties.jcr:title}" > ${properties.jcr:title} </h1>$stem$,
  '[{"text": "data-sly"}, {"text": "if-exists"}, {"text": "data-sly-test"}, {"text": "if-present"}]'::jsonb,
  2,
  $exp$HTL (Sightly) uses data-sly-* block statements and expression language; the correct syntax/option is: data-sly-test.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: data-sly-test.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','sling-models'], 'behavior prediction',
  $code$/* AEM · sling-models */
// An AEM developer in the process of creating a custom component. The Developer needs to know which interface to implement for the Sling Model to automatically be recognized by the JSON model API. Indicate which interface is needed in the missing code to complet$code$,
  'java',
  $stem$An AEM developer in the process of creating a custom component. The Developer needs to know which interface to implement for the Sling Model to automatically be recognized by the JSON model API. Indicate which interface is needed in the missing code to complete this code. public interface CustomComponent extends { public String getMessage (); }$stem$,
  '[{"text": "ExporterType"}, {"text": "Exporter"}, {"text": "ComponentControl"}, {"text": "ComponentExporter"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: ComponentExporter.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: ComponentExporter.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem','archetype'], 'behavior prediction',
  $code$/* AEM · archetype */
// An AEM developer is in the process of creating a custom component to display information on images within an app called snow, specifically name, size, and date taken. A folder has been created in the ui.apps module under /apps/snow/components. The folder is na$code$,
  'java',
  $stem$An AEM developer is in the process of creating a custom component to display information on images within an app called snow, specifically name, size, and date taken. A folder has been created in the ui.apps module under /apps/snow/components. The folder is named custom-component. Which file needs to be created to hold the component definition?$stem$,
  '[{"text": ".content.xml"}, {"text": ".images.xml"}, {"text": ".snow.xml"}, {"text": ".definition.xml"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: .content.xml.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: .content.xml.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'aem', 'medium', ARRAY['aem','cloud-service','testing'], 'behavior prediction',
  $code$/* AEM · cloud-service */
// An AEM developer wants to allow non-developers to work with pipelines within AEM as a Cloud Service. The developer wants to use an existing environment type and the environment can only involve non-production pipelines. Which AEM Environment type is associated$code$,
  'java',
  $stem$An AEM developer wants to allow non-developers to work with pipelines within AEM as a Cloud Service. The developer wants to use an existing environment type and the environment can only involve non-production pipelines. Which AEM Environment type is associated strictly with non-production pipelines within AEM as a Cloud Service?$stem$,
  '[{"text": "Development"}, {"text": "Stage"}, {"text": "Production"}, {"text": "Testing"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Development.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Development.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','content-fragments','editable-templates'], 'behavior prediction',
  $code$/* AEM · content-fragments */
// An AEM developer wants to create a Content Fragment Model. The option to do so is not available. The developer wants to make sure the model stays local to the project. What does the developer need to do to have the option to create a Content Fragment model?$code$,
  'java',
  $stem$An AEM developer wants to create a Content Fragment Model. The option to do so is not available. The developer wants to make sure the model stays local to the project. What does the developer need to do to have the option to create a Content Fragment model?$stem$,
  '[{"text": "Define the structure of a Content Fragment Model"}, {"text": "Add an instance of the ContentFragmentModels class"}, {"text": "Enable Content Fragment Models through the Configuration Browser"}, {"text": "Extend the ContentFragmentModels class"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Enable Content Fragment Models through the Configuration Browser.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Enable Content Fragment Models through the Configuration Browser.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','packages'], 'behavior prediction',
  $code$/* AEM · packages */
// An AEM Developer has created a custom component and wants to start using it on a page within a local AEM instance. The developer currently has no means by which to add the component to the page or any other page within the instance. What does the developer nee$code$,
  'java',
  $stem$An AEM Developer has created a custom component and wants to start using it on a page within a local AEM instance. The developer currently has no means by which to add the component to the page or any other page within the instance. What does the developer need to run to deploy the code to the instance?$stem$,
  '[{"text": "$mvn update install -PautolnstallSinglePackage"}, {"text": "$mvn clean install -PautolnstallSinglePackage"}, {"text": "$mvn install -PautolnstallSinglePackage"}, {"text": "$mvn update -PautolnstallSinglePackage"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: $mvn clean install -PautolnstallSinglePackage.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: $mvn clean install -PautolnstallSinglePackage.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow','packages'], 'behavior prediction',
  $code$/* AEM · workflow */
// A new AEM developer wants to create a workflow model programmatically. The developer wants to create a folder called workflowdrafts in the correct folder within AEM. What does the complete path to the model look like?$code$,
  'java',
  $stem$A new AEM developer wants to create a workflow model programmatically. The developer wants to create a folder called workflowdrafts in the correct folder within AEM. What does the complete path to the model look like?$stem$,
  '[{"text": "/var/packages/workflow/models/workflowdrafts"}, {"text": "/var/workflow/workflowdrafts"}, {"text": "/var/models/workflowdrafts"}, {"text": "/var/workflow/models/workflowdrafts"}]'::jsonb,
  3,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: /var/workflow/models/workflowdrafts.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: /var/workflow/models/workflowdrafts.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','htl','clientlibs'], 'behavior prediction',
  $code$/* AEM · htl */
// An AEM developer wants to load CSS files of a client library into a webpage. The developer has completed most of the code but does not know what to put in the missing space. Which code should fill the missing space in this code example? <head> <!-- HTML meta-d$code$,
  'java',
  $stem$An AEM developer wants to load CSS files of a client library into a webpage. The developer has completed most of the code but does not know what to put in the missing space. Which code should fill the missing space in this code example? <head> <!-- HTML meta-data --> <sly _______ = "${clientlib.css @ categories='myCategory'}" /> </head>$stem$,
  '[{"text": "data-sly-call"}, {"text": "data-sly"}, {"text": "data-sly-get"}, {"text": "data-sly-use"}]'::jsonb,
  0,
  $exp$AEM SPA Editor wiring uses MapTo / Page Model JSON. Correct choice: data-sly-call.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: data-sly-call.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow'], 'behavior prediction',
  $code$/* AEM · workflow */
// An app needs a workflow to trigger another workflow. Which type of workflow step, when run, starts another workflow model?$code$,
  'java',
  $stem$An app needs a workflow to trigger another workflow. Which type of workflow step, when run, starts another workflow model?$stem$,
  '[{"text": "Join"}, {"text": "Process"}, {"text": "Split"}, {"text": "Container"}]'::jsonb,
  3,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: Container.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Container.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','oak'], 'behavior prediction',
  $code$/* AEM · oak */
// An instance of AEM is running CRX2 and will require a migration to Oak (CRX3) when upgrading directly to AEM 6.5. Which version of AEM is running?$code$,
  'java',
  $stem$An instance of AEM is running CRX2 and will require a migration to Oak (CRX3) when upgrading directly to AEM 6.5. Which version of AEM is running?$stem$,
  '[{"text": "5.6"}, {"text": "6.2"}, {"text": "6.0"}, {"text": "6.1"}]'::jsonb,
  2,
  $exp$Oak query/index design must match predicates and path restrictions. Correct approach: 6.0.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 6.0.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','clientlibs','archetype','packages'], 'behavior prediction',
  $code$/* AEM · clientlibs */
// What needs to be run to produce the clientlib-site and clientlib-dependencies client libraries into the ui.apps back-end module?$code$,
  'java',
  $stem$What needs to be run to produce the clientlib-site and clientlib-dependencies client libraries into the ui.apps back-end module?$stem$,
  '[{"text": "npm run dev"}, {"text": "mvn run dev"}, {"text": "mvn clean install -PautolnstallPackage"}, {"text": "npm clean install - PautolnstallPackage"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: npm run dev.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: npm run dev.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem','archetype','packages'], 'behavior prediction',
  $code$/* AEM · archetype */
// Within the AEM Project Archetype, developer is looking for add browser plug-ins within the main folder of the project. The developer also wants to add Ul-based plugins and knows there is a file with plugin sections to where plugin configurations can be defined$code$,
  'java',
  $stem$Within the AEM Project Archetype, developer is looking for add browser plug-ins within the main folder of the project. The developer also wants to add Ul-based plugins and knows there is a file with plugin sections to where plugin configurations can be defined. Which file is that?$stem$,
  '[{"text": "Parent POM"}, {"text": "plugins.xml"}, {"text": "ui.apps/pom.xml"}, {"text": "filter.xml"}]'::jsonb,
  0,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Parent POM.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Parent POM.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','workflow','testing'], 'behavior prediction',
  $code$/* AEM · workflow */
// A new developer changes a workflow after it has been run for the first time. However, upon testing the workflow, the changes are not reflected when the workflow runs. What is the most likely cause of this problem?$code$,
  'java',
  $stem$A new developer changes a workflow after it has been run for the first time. However, upon testing the workflow, the changes are not reflected when the workflow runs. What is the most likely cause of this problem?$stem$,
  '[{"text": "The workflow needs to be debugged first"}, {"text": "A new version of the runtime version was not saved"}, {"text": "The runtime version of the workflow was not updated"}, {"text": "The Sync was not triggered in the workflow model"}]'::jsonb,
  3,
  $exp$Workflow APIs expose args via MetaDataMap / process arguments. Correct: The Sync was not triggered in the workflow model.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: The Sync was not triggered in the workflow model.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'easy', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// For a default installation of AEM, on which port does the Author instance run?$code$,
  'java',
  $stem$For a default installation of AEM, on which port does the Author instance run?$stem$,
  '[{"text": "8080"}, {"text": "4503"}, {"text": "4502"}, {"text": "80"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: 4502.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: 4502.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','spa','archetype'], 'behavior prediction',
  $code$/* AEM · spa */
// A developer wants to use the AEM Project Archetype as the developer as the developer is working on a minimal, best-practice based AEM project. The archetype is based off which type of template?$code$,
  'java',
  $stem$A developer wants to use the AEM Project Archetype as the developer as the developer is working on a minimal, best-practice based AEM project. The archetype is based off which type of template?$stem$,
  '[{"text": "Gradle"}, {"text": "React.js"}, {"text": "Angular.js"}, {"text": "Maven"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Maven.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Maven.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A new AEM administrator needs to learn the URL for the Configuration tab of the Web Console for an AEM instance on a local server. Which path should the administrator use to get to the console?$code$,
  'java',
  $stem$A new AEM administrator needs to learn the URL for the Configuration tab of the Web Console for an AEM instance on a local server. Which path should the administrator use to get to the console?$stem$,
  '[{"text": "//localhost:4502/webConsole/configMgr"}, {"text": "//localhost:4502/console/configMgr"}, {"text": "//localhost:4502/system/console/configMgr"}, {"text": "//localhost:4502/system/webConsole/configMgr"}]'::jsonb,
  2,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: //localhost:4502/system/console/configMgr.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: //localhost:4502/system/console/configMgr.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'medium', ARRAY['aem','cloud-service'], 'behavior prediction',
  $code$/* AEM · cloud-service */
// A developer is in the Environments area of an AEM instance and can access the Developer Console for all versions of the instance. A user wants to run some tests within a Developer Console. The company has a strict policy against allowing non-developers to be i$code$,
  'java',
  $stem$A developer is in the Environments area of an AEM instance and can access the Developer Console for all versions of the instance. A user wants to run some tests within a Developer Console. The company has a strict policy against allowing non-developers to be in the Developer Console within a production, stage, or development environment. What should be set up to allow the user to use the Developer Console?$stem$,
  '[{"text": "Make the user an administrator"}, {"text": "Ensure the user has access to the Cloud Manager Sandbox Program"}, {"text": "Set up a new test AEM environment"}, {"text": "Set up a test sandbox instance"}]'::jsonb,
  1,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Ensure the user has access to the Cloud Manager Sandbox Program.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Ensure the user has access to the Cloud Manager Sandbox Program.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
),
(
  'published', 'aem', 'hard', ARRAY['aem'], 'behavior prediction',
  $code$/* AEM · concepts */
// A developer wants to add a list of IP addresses to be allowed in the Author version of an app. The developer navigates to the Environments screen but does not have access to the IP Allow Lists area. The same problem exists when the developer navigates to the P$code$,
  'java',
  $stem$A developer wants to add a list of IP addresses to be allowed in the Author version of an app. The developer navigates to the Environments screen but does not have access to the IP Allow Lists area. The same problem exists when the developer navigates to the Publish version of the app. Which roles are eligible to add an IP Allow list? (Choose two)$stem$,
  '[{"text": "List Manager"}, {"text": "Site Administrator"}, {"text": "Deployment Manager"}, {"text": "Business Owner"}]'::jsonb,
  3,
  $exp$Based on AEM platform behavior and Adobe Experience League guidance, the correct option is: Business Owner. The source item was multi-select; this practice card highlights the key required selection and reasoning.$exp$,
  $tp$1) Map the stem to the AEM feature area. 2) Drop options that name the wrong console, content type, or API. 3) Keep the option that matches Adobe-recommended practice: Business Owner.$tp$,
  'https://experienceleague.adobe.com/', 'learnmaster-aem-csv', 'Educational'
);

