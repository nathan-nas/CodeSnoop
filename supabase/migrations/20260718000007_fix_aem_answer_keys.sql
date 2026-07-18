-- Apply audited answer corrections for LearnMaster AEM seed
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$Least complex sharing is passing model props down the tree. Centralized broadcast and state libraries add overhead; extending the container is more invasive than props for simple cases.$exp$,
  thought_process = $tp$1) Ask for least complex. 2) Props drilling is simplest. 3) Redux/broadcast/container are heavier. 4) Choose model props.$tp$,
  topic_tags = ARRAY['aem','spa','react','state'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A project requires sharing information between SPA components. Which is the least complex approach to achieve that objective?$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$cq:allowedTemplates already matches, but allowedParents on T does not match P's template. Align allowedParents to P's template. Clearing also works but is looser; application migration is not the stated failing check.$exp$,
  thought_process = $tp$1) allowedTemplates already OK. 2) Failure is allowedParents mismatch. 3) Make allowedParents match P's template. 4) Reject path-only/clear-first as best fix.$tp$,
  topic_tags = ARRAY['aem','templates','pages'],
  difficulty = 'hard'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer needs to make template T available as a child page of page P. The developer has determined that: Template T matches cq:allowedTemplates property on page P. Template T has no atlowedPaths Property set. Template T is not in the same application as page P. The template of page P has no match on the allowedParents property of template T. Template T has no match on the allowedTemplate property on the temptate of page P. What should the developer change?$stem$;
UPDATE public.questions SET
  correct_option_index = 3,
  explanation = $exp$Path-scoped Lucene indexes need evaluatePathRestrictions with includedPaths/queryPaths. Without path config, default indexes win. Boost or switching to property index is not the usual fix.$exp$,
  thought_process = $tp$1) Custom index not selected. 2) Missing path restriction properties. 3) includedPaths + evaluatePathRestrictions common fix. 4) Reject boost/replace answers.$tp$,
  topic_tags = ARRAY['aem','oak','indexing'],
  difficulty = 'hard'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$An AEM Developer creates a custom OAK index for /content/mywebsite under /oak:index node. While testing the live site. It is found that the index is not being applied to any query within the website. Default Lucene indexes with high cost are being picked up by the AEM. What is the most likely of the issue?$stem$;
UPDATE public.questions SET
  correct_option_index = 2,
  explanation = $exp$Embed both bundles in one package; OSGi Import-Package wiring resolves dependencies without installationOrder or split packages. Felix manual upload is not efficient for all environments.$exp$,
  thought_process = $tp$1) A depends on B via Import-Package. 2) OSGi resolves wiring. 3) One package embedding both is enough. 4) Choose c.$tp$,
  topic_tags = ARRAY['aem','osgi','packages','bundles'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A Custom application contains Bundle A and Bundle B. Bundle A has a dependency to Bundle B via Import-Package. How can both bundles be deployed most efficiently across all the environments?$stem$;
UPDATE public.questions SET
  correct_option_index = 3,
  explanation = $exp$Valid omnichannel tools include Sling Model Exporter (CF/XF), Assets HTTP API, and Content Services. GraphQL is for Content Fragments, not Experience Fragments, so options claiming GraphQL for XF are inaccurate.$exp$,
  thought_process = $tp$1) List headless tools. 2) GraphQL ≠ XF. 3) Drop GraphQL-for-XF options. 4) Choose Sling Model Exporter + Assets HTTP API + Content Services.$tp$,
  topic_tags = ARRAY['aem','headless','content-services','content-fragments'],
  difficulty = 'hard'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$AEM supports traditional, Headless and Hybrid delivery capabilities in various ways. Which of the following are the tools enabling Omnichannel experience capabilities in AEM ?$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$Participant steps require persisted work items and defeat transient workflows. Remove the Participant Step (not a normal Process Step).$exp$,
  thought_process = $tp$1) Transient workflow broken. 2) Participant steps force persistence. 3) Process step is not the classic breaker. 4) Choose Participant Step.$tp$,
  topic_tags = ARRAY['aem','workflow','transient-workflow'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A Project has a transient workflow. But a specific step defeats the purpose of making workflow to transient. creates a sling job to proceed further and generates error messages in log files. To make it better which step must be removed?$stem$;
UPDATE public.questions SET
  correct_option_index = 1,
  explanation = $exp$Context-aware config lives under /conf; anonymous publish needs read on /conf. /etc is wrong; write for anonymous is wrong.$exp$,
  thought_process = $tp$1) CACONFIG from /conf. 2) Works as admin, null as anonymous. 3) Grant anonymous read on /conf. 4) Reject /etc.$tp$,
  topic_tags = ARRAY['aem','sling-caconfig','security','conf'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer is using sling context-aware configuration trying to get the configuration resource using: @Reference Private configurationResourceResolver cfgResourceResolver ; confResource = cfgResourceResolver . getResource ( resource , Bucket_NAME , CONFIG_NAME ); This works as intended in author and in publish when logged in to publish as admin. However this gives a null when run as anonymous.$stem$;
UPDATE public.questions SET
  correct_option_index = 1,
  explanation = $exp$Add a page-properties tab by overlaying cq:dialog under the page proxy and merging only the new tab so Core tabs remain inherited. Copying the whole dialog and deleting tabs loses inheritance; editing core is not upgrade-safe.$exp$,
  thought_process = $tp$1) Proxy page of core page. 2) Merger overlay for new tab. 3) Don't copy/remove all tabs. 4) Don't edit /apps/core.$tp$,
  topic_tags = ARRAY['aem','dialog','page-properties','sling-resource-merger'],
  difficulty = 'hard'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer has requirement to add a new custom tab to the page properties of a specific page. The sling:resourceType of the page is foo/components/page and the sling:resourceSuperType of that page is core/wcm/components/page/v2/page. What is the best approach?$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$Single Text element mode paragraph controls are Paragraph Scope and Paragraph Range.$exp$,
  thought_process = $tp$1) Single text + paragraph controls. 2) Scope and range. 3) Reject title/description. 4) Pair a and c; fixed index uses a.$tp$,
  topic_tags = ARRAY['aem','content-fragments','components'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$While configuring Content Fragment Component author has selected Display Mode as Single Text element . This enables the selection of one Multi-Line text element and enables paragraph control options. Which two properties will now determine the resulting paragraph system?(choose two)$stem$;
UPDATE public.questions SET
  correct_option_index = 2,
  explanation = $exp$Remove selectors with an empty selectors option (@selectors= / selectors=[]) or removeSelectors list. Bare @selectors is incomplete; brace syntax is invalid.$exp$,
  thought_process = $tp$1) Remove selectors from URL. 2) Empty selectors or removeSelectors. 3) Reject bare @selectors and braces. 4) Fixed index uses c.$tp$,
  topic_tags = ARRAY['aem','htl','selectors'],
  difficulty = 'hard'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer needs to remove selectors from this url 'path/page.woo.foo.html' so what should be the syntax? (choose two)$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$Experience Fragment export uses the plain selector. nocss/text are not the Adobe XF export selector for this question.$exp$,
  thought_process = $tp$1) Export XF. 2) plain selector. 3) nocss incorrect. 4) Choose plain.$tp$,
  topic_tags = ARRAY['aem','experience-fragments','json-exporter'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$While exporting the Experience Fragment to json what selector should be used?$stem$;
UPDATE public.questions SET
  correct_option_index = 1,
  explanation = $exp$Dispatcher /filter deny defaults to HTTP 404, not 403.$exp$,
  thought_process = $tp$1) Filter deny status. 2) Default 404. 3) 403 is a common misconception. 4) Choose 404.$tp$,
  topic_tags = ARRAY['aem','dispatcher','security','filter'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$What will be the default response of dispatcher if it is deny for some url in /filter property?$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$Use non-deprecated com.adobe.granite.workflow.exec.ParticipantStepChooser. day.cq ParticipantChooser is deprecated.$exp$,
  thought_process = $tp$1) Dynamic participant chooser. 2) Granite ParticipantStepChooser. 3) day.cq API deprecated. 4) Choose a.$tp$,
  topic_tags = ARRAY['aem','workflow','java-api'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer must create a workflow step that assigns a 'WorkItem' to the appropriate person based on who has the least amount work to do. The group that must perform the action is configured into the workflow. Which non-deprecated interface should the Java implementation class use to perform the assignment?$stem$;
UPDATE public.questions SET
  correct_option_index = 2,
  explanation = $exp$Save Threshold controls how many nodes are batched per save during package install. MergePreserve is ACL handling.$exp$,
  thought_process = $tp$1) Limit transient nodes per save. 2) Save Threshold. 3) MergePreserve ≠ batch size. 4) Choose Save Threshold.$tp$,
  topic_tags = ARRAY['aem','packages'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer is installing a content package with the package manager. The developer needs to restrict the approximate number of nodes in a batch that is saved to persistent storage in one transaction. How should the developer modify the number of transient nodes to be triggered until automatic saving?$stem$;
UPDATE public.questions SET
  correct_option_index = 2,
  explanation = $exp$Extend Core Carousel via sling:resourceSuperType proxy. Do not copy or edit core under /apps.$exp$,
  thought_process = $tp$1) Extend core carousel. 2) resourceSuperType. 3) Copying core is anti-pattern. 4) Choose c.$tp$,
  topic_tags = ARRAY['aem','core-components','sling'],
  difficulty = 'easy'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer wants to extend AEM Core Components to create a custom Carousel Component. How should the developer extend the Core Components?$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$Post-Hobbes, AEM 6.5+ recommends standard automation such as Selenium. React.js is not a testing framework.$exp$,
  thought_process = $tp$1) Recommended testing framework. 2) Selenium automation. 3) React.js is not testing. 4) Choose Selenium.$tp$,
  topic_tags = ARRAY['aem','testing','aem-6.5'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$An instance of AEM has been upgraded to version 6.5. With that upgrade, which testing framework is being recommended as the testing framework for that version and beyond?$stem$;
UPDATE public.questions SET
  correct_option_index = 2,
  explanation = $exp$Download full logs from Web Console Status → Log files. Sling Log Service configures loggers; it is not the zip download UI.$exp$,
  thought_process = $tp$1) Download full log files. 2) Status → Log files. 3) Reject Sing/Sling Log Service path. 4) Choose c.$tp$,
  topic_tags = ARRAY['aem','logging','web-console'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$From which AEM Web Console should a developer access and download full AEM Log Files?$stem$;
UPDATE public.questions SET
  correct_option_index = 3,
  explanation = $exp$Enable Style System for authors by defining style definitions on the editable template page/component policy. Clientlibs alone do not enable the Style System dialog.$exp$,
  thought_process = $tp$1) Style System dialog not enabled. 2) Define styles in policy. 3) Clientlibs ≠ enable dialog. 4) Choose d.$tp$,
  topic_tags = ARRAY['aem','style-system','editable-templates','policies'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer creates Editable Templates based on a custom Page component. The developer wants to leverage the Style System within the Editable Templates to allow authors to switch between the Dark and Light Theme. The Style System dialog is NOT enabled for the site. What should the developer do to resolve this issue?$stem$;
UPDATE public.questions SET
  correct_option_index = 2,
  explanation = $exp$Reindex Oak indexes after in-place upgrade so new definitions apply once; reindexing before can waste time.$exp$,
  thought_process = $tp$1) Save time around upgrade. 2) Reindex after. 3) Before risks double work. 4) Choose After.$tp$,
  topic_tags = ARRAY['aem','upgrade','oak','indexing'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A business wants to save time when doing an in-place upgrade of an AEM instance. To meet this requirement, when should Oak indexes be reindexed in relation to the upgrade itself?$stem$;
UPDATE public.questions SET
  correct_option_index = 0,
  explanation = $exp$CRX2 belongs to AEM 5.6.x. AEM 6.0+ is Oak, so a CRX2 instance upgrading directly to 6.5 is 5.6.$exp$,
  thought_process = $tp$1) Still on CRX2. 2) CRX2 = 5.6. 3) 6.x already Oak. 4) Choose 5.6.$tp$,
  topic_tags = ARRAY['aem','upgrade','oak','crx2'],
  difficulty = 'medium'
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$An instance of AEM is running CRX2 and will require a migration to Oak (CRX3) when upgrading directly to AEM 6.5. Which version of AEM is running?$stem$;
UPDATE public.questions SET
  explanation = $exp$Each REST item must become an AEM page using the draft page template with custom data binding/retrieval. Segments are for personalization, not page creation. Content Fragments and Experience Fragments do not create site pages from a page template in this scenario.$exp$,
  thought_process = $tp$1) Requirement is display each item as an AEM page with a draft page template. 2) Segments do not create pages. 3) CF/XF are not page-template page creation. 4) Choose create pages.$tp$,
  topic_tags = ARRAY['aem','pages','templates']
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A customer needs to store approximately 200 raw data items from REST API and display each item as an AEM page. A draft page template exists. Which Method should be used to meet this requirement?$stem$;
UPDATE public.questions SET
  explanation = $exp$Sling Models exporters (Jackson + jackson-dataformat-yaml) produce YAML. Register the YAML MIME/extension in Apache Sling MIME Type Service. Referrer Filter is unrelated; 'OSGi models' is not the Sling Models exporter feature.$exp$,
  thought_process = $tp$1) Need Sling Models YAML export. 2) Exporters are Sling Models, not OSGi models. 3) MIME mapping belongs in MIME Type Service. 4) Choose Sling Models + MIME Type Service.$tp$,
  topic_tags = ARRAY['aem','sling-models','osgi']
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$An AEM Developer receives requirements for Sling Models in a human-readable yaml format. A custom application needs to be built. The dependency is as shown: <dependency> <groupId> com.fasterxml.jackson.core </groupId> <artifactId> jackson-databind </artifactId> <version> 2.8.4 </version> <scope> provided </scope> </dependency> <dependency> <groupId> com.fasterxml.jackson.dataformat </groupId> <artifactId> jackson-datafirmat-yaml </artifactId> <version> 2.8.4 </version> </dependency>$stem$;
UPDATE public.questions SET
  explanation = $exp$JAAS SUFFICIENT means success returns immediately and later modules are skipped; failure continues down the list—exactly the described multi-LDAP behavior. OPTIONAL never short-circuits on success; REQUIRED must succeed; MANDATORY is not a standard JAAS flag.$exp$,
  thought_process = $tp$1) Success stops; failure continues. 2) That is SUFFICIENT (option b, spelled SUFFICENT). 3) OPTIONAL continues after success. 4) Reject REQUIRED/MANDATORY.$tp$,
  topic_tags = ARRAY['aem','oak','security','ldap']
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$A developer has multiple LDAP Authentication providers. The user is not required to pass the authentication test of the Authentication provider. If authentication succeeds, control is returned to the caller; no subsequent Authentication provider down the list is executed. . If authentication fails, authentication continues down the list of providers. What should be the JAAS Control flag value in Apache Jackrabbit Oak External Login Module configuration?$stem$;
UPDATE public.questions SET
  explanation = $exp$OSGi Configuration Manager creates/edits configurations for OSGi services. It does not create runmodes; 'bundles configurations' is incorrect terminology.$exp$,
  thought_process = $tp$1) What configMgr creates. 2) Service configurations. 3) Not runmodes/bundles. 4) Choose Service Configuration.$tp$,
  topic_tags = ARRAY['aem','osgi']
WHERE language = 'aem'
  AND source_file_path = 'learnmaster-aem-csv'
  AND question_stem = $stem$What type of configuration can be created in OSGI Configuration Manager?$stem$;
