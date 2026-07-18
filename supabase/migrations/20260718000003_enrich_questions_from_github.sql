-- Curated practice questions inspired by popular JS/Java learning repos.
-- Snippets are short educational excerpts with source attribution (MIT / educational use).

INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
-- ========== JavaScript: 33-js-concepts / closures ==========
(
  'published', 'javascript', 'medium', ARRAY['closures', 'scope'], 'behavior prediction',
  $code$function makeCounter() {
  let count = 0;
  return function () {
    count += 1;
    return count;
  };
}
const a = makeCounter();
const b = makeCounter();
console.log(a(), a(), b());$code$,
  'javascript',
  'What is printed?',
  '[{"text":"1 2 3"},{"text":"1 2 1"},{"text":"1 1 1"},{"text":"2 3 1"}]'::jsonb,
  1,
  'Each call to makeCounter() creates a new closure with its own count. a() runs twice → 1 then 2; b() starts fresh → 1.',
  '1) makeCounter returns an inner function closing over count. 2) a and b are separate calls → separate environments. 3) Trace a(), a(), then b().',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/closures', 'MIT'
),
-- ========== JavaScript: event loop / async ==========
(
  'published', 'javascript', 'medium', ARRAY['async', 'event loop'], 'behavior prediction',
  $code$console.log('A');
setTimeout(() => console.log('B'), 0);
Promise.resolve().then(() => console.log('C'));
console.log('D');$code$,
  'javascript',
  'What is the print order?',
  '[{"text":"A B C D"},{"text":"A D C B"},{"text":"A D B C"},{"text":"A C D B"}]'::jsonb,
  1,
  'Sync logs A then D. Microtasks (Promise then) run before macrotasks (setTimeout), so C before B.',
  '1) Run sync code. 2) Queue microtask vs macrotask. 3) Drain microtasks before next timer callback.',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/event-loop', 'MIT'
),
-- ========== JavaScript: this binding ==========
(
  'published', 'javascript', 'hard', ARRAY['this', 'functions'], 'behavior prediction',
  $code$const obj = {
  name: 'Ada',
  greet() {
    return this.name;
  },
};
const fn = obj.greet;
console.log(fn());$code$,
  'javascript',
  'In non-strict browser/global mode, what does fn() return?',
  '[{"text":"\"Ada\""},{"text":"undefined (or global name)"},{"text":"Throws TypeError always"},{"text":"\"greet\""}]'::jsonb,
  1,
  'Extracting the method loses the obj receiver. this is no longer obj, so this.name is not \"Ada\".',
  '1) Method vs bare function call. 2) this is set by call site. 3) fn() has no receiver.',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/this', 'MIT'
),
-- ========== JavaScript: equality ==========
(
  'published', 'javascript', 'easy', ARRAY['types', 'equality'], 'behavior prediction',
  $code$console.log([] == ![]);
console.log([] === ![]);$code$,
  'javascript',
  'What is printed?',
  '[{"text":"true true"},{"text":"true false"},{"text":"false false"},{"text":"false true"}]'::jsonb,
  1,
  '== coerces: ![] is false, [] becomes 0, false becomes 0 → true. === compares types → false.',
  '1) Evaluate ![]. 2) Apply ToPrimitive/ToNumber for ==. 3) Strict equality skips coercion.',
  'https://github.com/Asabeneh/30-Days-Of-JavaScript', '01_Day_Introduction', 'MIT'
),
-- ========== JavaScript: array methods ==========
(
  'published', 'javascript', 'easy', ARRAY['arrays', 'map'], 'behavior prediction',
  $code$const nums = [1, 2, 3];
const out = nums.map((n) => n * 2).filter((n) => n > 2);
console.log(out);$code$,
  'javascript',
  'What is printed?',
  '[{"text":"[1, 2, 3]"},{"text":"[2, 4, 6]"},{"text":"[4, 6]"},{"text":"[2, 4]"}]'::jsonb,
  2,
  'map → [2,4,6]; filter keeps values > 2 → [4,6].',
  '1) Apply map. 2) Apply filter predicate. 3) Collect result.',
  'https://github.com/Asabeneh/30-Days-Of-JavaScript', '05_Day_Arrays', 'MIT'
),
-- ========== JavaScript: destructuring / defaults ==========
(
  'published', 'javascript', 'medium', ARRAY['destructuring', 'defaults'], 'behavior prediction',
  $code$function greet({ name = 'Guest', age } = {}) {
  return `${name}:${age}`;
}
console.log(greet());
console.log(greet({ age: 30 }));$code$,
  'javascript',
  'What is printed?',
  '[{"text":"Guest:undefined then Guest:30"},{"text":"undefined:undefined then Guest:30"},{"text":"Throws on greet()"},{"text":"Guest:undefined then undefined:30"}]'::jsonb,
  0,
  'Default param {} lets greet() run. name defaults to Guest; age is undefined unless provided.',
  '1) Check default parameter. 2) Destructure with name default. 3) age has no default.',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/destructuring', 'MIT'
),
-- ========== JavaScript: promises / async ==========
(
  'published', 'javascript', 'medium', ARRAY['async', 'promises'], 'bug finding',
  $code$async function load() {
  return 42;
}
const value = load();
console.log(value + 1);$code$,
  'javascript',
  'What is the bug?',
  '[{"text":"async functions cannot return numbers"},{"text":"value is a Promise; adding 1 coerces oddly / is wrong"},{"text":"load must use await inside"},{"text":"console.log cannot print Promises"}]'::jsonb,
  1,
  'async functions always return a Promise. Without await, value is a Promise, not 42.',
  '1) async ⇒ Promise return. 2) Check call site for await. 3) Fix: await load().',
  'https://github.com/Asabeneh/30-Days-Of-JavaScript', '18_Day_Promises', 'MIT'
),
-- ========== JavaScript: optional chaining ==========
(
  'published', 'javascript', 'easy', ARRAY['null/undefined', 'optional chaining'], 'behavior prediction',
  $code$const user = { profile: null };
console.log(user.profile?.name ?? 'anon');
console.log(user.profile.name);$code$,
  'javascript',
  'What happens?',
  '[{"text":"Prints anon then undefined"},{"text":"Prints anon then throws TypeError"},{"text":"Throws on the first line"},{"text":"Prints null then null"}]'::jsonb,
  1,
  '?. short-circuits to undefined, ?? yields anon. Direct .name on null throws.',
  '1) Optional chain vs normal property access. 2) null has no name.',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/nullish', 'MIT'
),
-- ========== JavaScript30-style: DOM event / array from ==========
(
  'published', 'javascript', 'medium', ARRAY['arrays', 'dom'], 'behavior prediction',
  $code$const nodes = document.querySelectorAll('div');
// NodeList is array-like
console.log(typeof nodes.map);
const arr = [...nodes];
console.log(typeof arr.map);$code$,
  'javascript',
  'What is printed?',
  '[{"text":"function then function"},{"text":"undefined then function"},{"text":"function then undefined"},{"text":"object then function"}]'::jsonb,
  1,
  'NodeList is not a true Array, so .map is undefined until you convert with spread/Array.from.',
  '1) querySelectorAll returns NodeList. 2) Check Array.isArray / .map. 3) Spread copies to Array.',
  'https://github.com/wesbos/JavaScript30', '01 - JavaScript Drum Kit', 'MIT'
),
-- ========== Java: singleton (java-design-patterns) ==========
(
  'published', 'java', 'medium', ARRAY['design patterns', 'concurrency'], 'behavior prediction',
  $code$public final class IvoryTower {
  private static final IvoryTower INSTANCE = new IvoryTower();
  private IvoryTower() {}
  public static IvoryTower getInstance() {
    return INSTANCE;
  }
}
IvoryTower a = IvoryTower.getInstance();
IvoryTower b = IvoryTower.getInstance();
System.out.println(a == b);$code$,
  'java',
  'What is printed?',
  '[{"text":"false"},{"text":"true"},{"text":"Does not compile"},{"text":"Throws IllegalStateException"}]'::jsonb,
  1,
  'Eager singleton stores one static INSTANCE; getInstance always returns the same reference, so == is true.',
  '1) Identify singleton pattern. 2) Static final instance created once. 3) Compare references.',
  'https://github.com/iluwatar/java-design-patterns', 'singleton/.../IvoryTower.java', 'MIT'
),
-- ========== Java: BubbleSort complexity (TheAlgorithms/Java) ==========
(
  'published', 'java', 'medium', ARRAY['algorithms', 'sorting'], 'complexity reasoning',
  $code$public <T extends Comparable<T>> T[] sort(T[] array) {
  for (int i = 1, size = array.length; i < size; ++i) {
    boolean swapped = false;
    for (int j = 0; j < size - i; ++j) {
      if (greater(array[j], array[j + 1])) {
        swap(array, j, j + 1);
        swapped = true;
      }
    }
    if (!swapped) break;
  }
  return array;
}$code$,
  'java',
  'What is the typical worst-case time complexity?',
  '[{"text":"O(n)"},{"text":"O(n log n)"},{"text":"O(n²)"},{"text":"O(1)"}]'::jsonb,
  2,
  'Nested loops over the array yield O(n²) in the worst case (reverse-sorted). Best case can be O(n) with the swapped flag.',
  '1) Count nested iterations. 2) Distinguish best vs worst. 3) Recall bubble sort.',
  'https://github.com/TheAlgorithms/Java', 'src/main/java/.../BubbleSort.java', 'MIT'
),
-- ========== Java: equals vs == ==========
(
  'published', 'java', 'easy', ARRAY['equality', 'strings'], 'bug finding',
  $code$String a = new String("hi");
String b = new String("hi");
System.out.println(a == b);
System.out.println(a.equals(b));$code$,
  'java',
  'What is printed?',
  '[{"text":"true true"},{"text":"false true"},{"text":"true false"},{"text":"false false"}]'::jsonb,
  1,
  '== compares references (distinct new String objects). equals compares content → true.',
  '1) new creates distinct objects. 2) == vs equals. 3) Prefer equals for value equality.',
  'https://github.com/in28minutes/java-a-course-for-beginners', 'strings-equality', 'Educational'
),
-- ========== Java: ArrayList CME ==========
(
  'published', 'java', 'hard', ARRAY['collections', 'concurrency'], 'behavior prediction',
  $code$List<String> list = new ArrayList<>();
list.add("a");
for (String s : list) {
  list.add("b");
}$code$,
  'java',
  'What happens?',
  '[{"text":"list becomes [a, b]"},{"text":"Infinite loop"},{"text":"Throws ConcurrentModificationException"},{"text":"Compiles but skips add"}]'::jsonb,
  2,
  'Enhanced-for uses a fail-fast iterator; structural modification during iteration throws ConcurrentModificationException.',
  '1) for-each ⇒ iterator. 2) add mutates structure. 3) Fail-fast detects modCount change.',
  'https://github.com/in28minutes/java-a-course-for-beginners', 'collections', 'Educational'
),
-- ========== Java: streams ==========
(
  'published', 'java', 'medium', ARRAY['streams', 'collections'], 'behavior prediction',
  $code$List<Integer> nums = List.of(1, 2, 3, 4, 5);
int sum = nums.stream()
    .filter(n -> n % 2 == 1)
    .map(n -> n * n)
    .reduce(0, Integer::sum);
System.out.println(sum);$code$,
  'java',
  'What is printed?',
  '[{"text":"9"},{"text":"35"},{"text":"25"},{"text":"16"}]'::jsonb,
  1,
  'Odds 1,3,5 → squares 1,9,25 → sum 35.',
  '1) filter odds. 2) map square. 3) reduce sum.',
  'https://github.com/in28minutes/java-a-course-for-beginners', 'streams', 'Educational'
),
-- ========== Java: Optional ==========
(
  'published', 'java', 'medium', ARRAY['null', 'optional'], 'bug finding',
  $code$Optional<String> name = Optional.ofNullable(null);
System.out.println(name.get());$code$,
  'java',
  'What happens?',
  '[{"text":"Prints null"},{"text":"Prints Optional.empty"},{"text":"Throws NoSuchElementException"},{"text":"Does not compile"}]'::jsonb,
  2,
  'get() on empty Optional throws NoSuchElementException. Prefer orElse / ifPresent.',
  '1) ofNullable(null) → empty. 2) get() requires value. 3) Use safer APIs.',
  'https://github.com/iluwatar/java-design-patterns', 'optional-usage', 'MIT'
),
-- ========== Java: HashMap null ==========
(
  'published', 'java', 'easy', ARRAY['collections', 'hashmap'], 'behavior prediction',
  $code$Map<String, Integer> map = new HashMap<>();
map.put(null, 1);
map.put("a", null);
System.out.println(map.get(null));
System.out.println(map.containsKey("a"));$code$,
  'java',
  'What is printed?',
  '[{"text":"null then false"},{"text":"1 then true"},{"text":"Throws NullPointerException"},{"text":"1 then false"}]'::jsonb,
  1,
  'HashMap allows one null key and null values. get(null) → 1; containsKey(\"a\") → true even if value is null.',
  '1) HashMap null policy. 2) containsKey vs get for null values.',
  'https://github.com/in28minutes/java-a-course-for-beginners', 'collections/hashmap', 'Educational'
),
-- ========== Java: override vs overload ==========
(
  'published', 'java', 'medium', ARRAY['oop', 'inheritance'], 'behavior prediction',
  $code$class Animal {
  String speak() { return "…"; }
}
class Dog extends Animal {
  @Override
  String speak() { return "woof"; }
}
Animal a = new Dog();
System.out.println(a.speak());$code$,
  'java',
  'What is printed?',
  '[{"text":"…"},{"text":"woof"},{"text":"Does not compile"},{"text":"Throws ClassCastException"}]'::jsonb,
  1,
  'Instance method dispatch is virtual: runtime type Dog selects Dog.speak() → woof.',
  '1) Static type Animal, runtime Dog. 2) Overridden instance methods are polymorphic.',
  'https://github.com/in28minutes/java-a-course-for-beginners', 'oop/inheritance', 'Educational'
),
-- ========== JavaScript: prototype ==========
(
  'published', 'javascript', 'hard', ARRAY['prototypes', 'objects'], 'behavior prediction',
  $code$function Person(name) {
  this.name = name;
}
Person.prototype.hello = function () {
  return `hi ${this.name}`;
};
const p = new Person('Ada');
console.log(p.hello());
console.log(p.hasOwnProperty('hello'));$code$,
  'javascript',
  'What is printed?',
  '[{"text":"hi Ada then true"},{"text":"hi Ada then false"},{"text":"undefined then false"},{"text":"Throws"}]'::jsonb,
  1,
  'hello is found on the prototype chain, so the call works, but it is not an own property → hasOwnProperty false.',
  '1) new links [[Prototype]]. 2) Method lookup walks the chain. 3) hasOwnProperty only checks own keys.',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/prototype', 'MIT'
),
-- ========== JavaScript: hoisting ==========
(
  'published', 'javascript', 'medium', ARRAY['hoisting', 'scope'], 'behavior prediction',
  $code$console.log(a);
var a = 1;
console.log(b);
let b = 2;$code$,
  'javascript',
  'What happens?',
  '[{"text":"undefined then 2"},{"text":"undefined then ReferenceError"},{"text":"ReferenceError then ReferenceError"},{"text":"1 then 2"}]'::jsonb,
  1,
  'var is hoisted and initialized as undefined. let is in the temporal dead zone until initialized → ReferenceError on console.log(b).',
  '1) var vs let hoisting. 2) TDZ for let/const.',
  'https://github.com/leonardomso/33-js-concepts', 'concepts/hoisting', 'MIT'
),
-- ========== project-based / practical bug: JSON parse ==========
(
  'published', 'javascript', 'easy', ARRAY['error handling', 'json'], 'bug finding',
  $code$const raw = '{name: Ada}';
const data = JSON.parse(raw);
console.log(data.name);$code$,
  'javascript',
  'What happens?',
  '[{"text":"Prints Ada"},{"text":"Prints undefined"},{"text":"Throws SyntaxError"},{"text":"Prints {name: Ada}"}]'::jsonb,
  2,
  'JSON requires double-quoted keys/strings. `{name: Ada}` is invalid JSON → JSON.parse throws SyntaxError.',
  '1) Recall JSON grammar. 2) Unquoted keys/values are invalid. 3) Use JSON.stringify-compatible input.',
  'https://github.com/practical-tutorials/project-based-learning', 'javascript', 'MIT'
);
