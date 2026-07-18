INSERT INTO public.questions (
  status, language, difficulty, topic_tags, skill_type,
  snippet_code, snippet_language, question_stem, options,
  correct_option_index, explanation, thought_process,
  source_repo_url, source_file_path, source_license
) VALUES
(
  'published', 'javascript', 'easy', ARRAY['async', 'promises'], 'behavior prediction',
  $code$async function loadUser(id) {
  const res = await fetch(`/api/users/${id}`);
  if (!res.ok) throw new Error('failed');
  return res.json();
}

const user = loadUser(1);
console.log(user.name);$code$,
  'javascript',
  'What happens when this code runs?',
  '[{"text":"It prints the user name from the API"},{"text":"It throws because user is a Promise, not the resolved value"},{"text":"It prints undefined without error"},{"text":"It blocks until fetch completes then prints the name"}]'::jsonb,
  1,
  'loadUser returns a Promise. Without await (or .then), user is a Promise object, so user.name is undefined and typically you get a TypeError when treating it as data — the key bug is missing await before using the result.',
  '1) Notice loadUser is async → returns a Promise. 2) Check call site: no await. 3) Ask what console.log receives — a Promise, not { name }. 4) Conclude the bug is using the Promise as if it were resolved data.',
  'https://github.com/example/codesnoop-seeds', 'js/async-missing-await.js', 'MIT'
),
(
  'published', 'javascript', 'medium', ARRAY['null/undefined', 'types'], 'bug finding',
  $code$function greet(user) {
  return `Hello, ${user.name.toUpperCase()}`;
}

console.log(greet({ name: null }));$code$,
  'javascript',
  'Where is the bug?',
  '[{"text":"Template strings cannot interpolate objects"},{"text":"user.name is null, so calling toUpperCase throws"},{"text":"greet must be async"},{"text":"console.log cannot print strings"}]'::jsonb,
  1,
  'user exists, but user.name is null. null has no toUpperCase method, so this throws a TypeError at runtime.',
  '1) Trace the argument: { name: null }. 2) Evaluate user.name → null. 3) Method call on null throws. 4) Guard with optional chaining or a default before calling string methods.',
  'https://github.com/example/codesnoop-seeds', 'js/null-name.js', 'MIT'
),
(
  'published', 'javascript', 'medium', ARRAY['closures', 'async'], 'behavior prediction',
  $code$for (var i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 0);
}$code$,
  'javascript',
  'What does this print?',
  '[{"text":"0 then 1 then 2"},{"text":"3 then 3 then 3"},{"text":"undefined three times"},{"text":"0 then 0 then 0"}]'::jsonb,
  1,
  'var is function-scoped. By the time the timeouts run, the loop finished and i is 3. All three callbacks close over the same i.',
  '1) Identify var (not let). 2) setTimeout callbacks run after the loop. 3) Shared binding i ends at 3. 4) Contrast with let, which would print 0 1 2.',
  'https://github.com/example/codesnoop-seeds', 'js/var-closure-loop.js', 'MIT'
),
(
  'published', 'javascript', 'hard', ARRAY['async', 'error handling'], 'behavior prediction',
  $code$Promise.resolve(1)
  .then(() => { throw new Error('boom'); })
  .then(() => console.log('ok'))
  .catch(() => console.log('caught'))
  .then(() => console.log('after'));$code$,
  'javascript',
  'What is printed?',
  '[{"text":"ok then after"},{"text":"caught then after"},{"text":"only caught"},{"text":"boom (uncaught)"}]'::jsonb,
  1,
  'The throw rejects the chain; the next then is skipped; catch handles it and logs "caught"; a then after catch runs with the catch''s resolution, so "after" also prints.',
  '1) Walk the promise chain left to right. 2) throw → reject. 3) Skip success handlers until catch. 4) Remember catch returns a resolved promise unless it rethrows.',
  'https://github.com/example/codesnoop-seeds', 'js/promise-catch-chain.js', 'MIT'
),
(
  'published', 'java', 'easy', ARRAY['null', 'strings'], 'bug finding',
  $code$String name = null;
System.out.println(name.length());$code$,
  'java',
  'What happens?',
  '[{"text":"Prints 0"},{"text":"Prints null"},{"text":"Throws NullPointerException"},{"text":"Does not compile"}]'::jsonb,
  2,
  'Calling an instance method on a null reference throws NullPointerException at runtime.',
  '1) name is null. 2) .length() is an instance call. 3) NPE. 4) Check null (or use Optional) before dereferencing.',
  'https://github.com/example/codesnoop-seeds', 'java/NullLength.java', 'MIT'
),
(
  'published', 'java', 'medium', ARRAY['streams', 'collections'], 'behavior prediction',
  $code$List<Integer> nums = List.of(1, 2, 3, 4);
List<Integer> result = nums.stream()
    .filter(n -> n % 2 == 0)
    .map(n -> n * 2)
    .toList();
System.out.println(result);$code$,
  'java',
  'What is printed?',
  '[{"text":"[1, 2, 3, 4]"},{"text":"[2, 4]"},{"text":"[4, 8]"},{"text":"[2, 4, 6, 8]"}]'::jsonb,
  2,
  'Even numbers 2 and 4 pass the filter, then each is doubled → 4 and 8.',
  '1) Start from source list. 2) Apply filter (keep evens). 3) Apply map (*2). 4) Collect and print.',
  'https://github.com/example/codesnoop-seeds', 'java/StreamFilterMap.java', 'MIT'
),
(
  'published', 'java', 'medium', ARRAY['equality', 'strings'], 'bug finding',
  $code$String a = new String("hi");
String b = new String("hi");
if (a == b) {
  System.out.println("same");
} else {
  System.out.println("different");
}$code$,
  'java',
  'What is printed?',
  '[{"text":"same"},{"text":"different"},{"text":"Does not compile"},{"text":"Throws exception"}]'::jsonb,
  1,
  '== compares references. new String("hi") creates distinct objects, so a == b is false even though contents match. Use equals for content.',
  '1) Note both are constructed with new. 2) == is reference equality. 3) Distinct objects → different. 4) Prefer Objects.equals / String.equals for value equality.',
  'https://github.com/example/codesnoop-seeds', 'java/StringEq.java', 'MIT'
),
(
  'published', 'java', 'hard', ARRAY['concurrency', 'collections'], 'behavior prediction',
  $code$List<String> list = new ArrayList<>();
list.add("a");
for (String s : list) {
  list.add("b");
}$code$,
  'java',
  'What happens when this runs?',
  '[{"text":"list becomes [a, b]"},{"text":"Infinite loop adding b forever"},{"text":"Throws ConcurrentModificationException"},{"text":"Compiles but silently skips the add"}]'::jsonb,
  2,
  'Enhancing-for uses an iterator that fails fast if the list is structurally modified during iteration, throwing ConcurrentModificationException.',
  '1) Identify enhanced-for → iterator. 2) Structural modification (add) inside loop. 3) Fail-fast iterators detect modCount change. 4) Use Iterator.remove, CopyOnWriteArrayList, or collect-then-add patterns instead.',
  'https://github.com/example/codesnoop-seeds', 'java/CmeLoop.java', 'MIT'
);
