import ceylon.language.meta.declaration {
    Declaration,
    ClassDeclaration
}
import ceylon.test.annotation {
    AfterTestAnnotation,
    BeforeTestAnnotation,
    TestAnnotation,
    TestSuiteAnnotation,
    TestExecutorAnnotation,
    TestListenersAnnotation,
    IgnoreAnnotation,
    TagAnnotation
}


"Marks a function as being a test.
 Only nullary functions should be annotated with `test`.
 
 Example of simplest test:
 
     test
     shared void shouldAlwaysSucceed() {}
"
shared annotation TestAnnotation test() => TestAnnotation();


"Annotation to specify test suite, which allow combine several tests or test suites and run them together.
 
     testSuite({`class YodaTest`,
                `class DarthVaderTest`,
                `function starOfDeathTestSuite`})
     shared void starwarsTestSuite() {}
"
shared annotation TestSuiteAnnotation testSuite(
    "The program elements from which tests will be executed."
    {Declaration+} sources) => TestSuiteAnnotation(sources);


"Annotation to specify custom [[TestExecutor]] implementation, which will be used for running test.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 If multiple occurrences will be found, the most closest will be used.
 
      testExecutor(`class ArquillianTestExecutor`)
      package com.acme;
"
shared annotation TestExecutorAnnotation testExecutor(
    "The class declaration of [[TestExecutor]]."
    ClassDeclaration executor) => TestExecutorAnnotation(executor);


"Annotation to specify custom [[TestListener]]s, which will be used during running test.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 If multiple occurrences will be found, all listeners will be used.
 
     testListeners({`class DependencyInjectionTestListener`,
                    `class TransactionalTestListener`})
     package com.acme;
"
shared annotation TestListenersAnnotation testListeners(
    "The class declarations of [[TestListener]]s"
    {ClassDeclaration+} listeners) => TestListenersAnnotation(listeners);


"Marks a function which will be run before each test in its scope.
 
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `beforeTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
"
shared annotation BeforeTestAnnotation beforeTest() => BeforeTestAnnotation();


"Marks a function which will be run after each test in its scope.
 
 It allow to place common initialization logic into separate place.
 Only nullary functions should be annotated with `afterTest`.
 
     class StarshipTest() {
 
         beforeTest 
         void init() => starship.chargePhasers();
 
         afterTest 
         void dispose() => starship.shutdownSystems();
 "
shared annotation AfterTestAnnotation afterTest() => AfterTestAnnotation();


"Marks a test or group of tests which should not be executed, which will be skipped during test run.
 
 It can be set on several places: on concrete test, on class which contains tests, on whole package or even module.
 
     test
     ignore(\"still not implemented\")
     void shouldBeFasterThanLight() {
 
"
shared annotation IgnoreAnnotation ignore(
    "Reason why the test is ignored."
    String reason = "") => IgnoreAnnotation(reason);


"Marks a test or group of tests with one or more tags, 
 tags can be used for filtering, which tests will be executed.
 
 For example test, which is failing often, but from unknow reasons, 
 can be marked as _unstable_ ...
 
 ~~~~
 test
 tag(\"unstable\")
 shared void shouldSucceedWithLittleLuck() { ... }
 ~~~~
     
 ... and then excluded from test execution
 
 ~~~~plain
 $ceylon test --tag=!unstable com.acme.mymodule
 ~~~~
 
 ... or visa versa, we can execute only tests with this tag
 
 ~~~~plain
 $ceylon test --tag=unstable com.acme.mymodule
 ~~~~
 "
shared annotation TagAnnotation tag(
    "One or more tags associated with the test."
    {String+} tags) => TagAnnotation(tags);