/** Curated topics for profile picker (aligned with seeded question tags). */
export const TOPIC_CATALOG = [
  "closures",
  "scope",
  "async",
  "event loop",
  "promises",
  "this",
  "functions",
  "types",
  "equality",
  "arrays",
  "map",
  "destructuring",
  "defaults",
  "null/undefined",
  "optional chaining",
  "dom",
  "prototypes",
  "objects",
  "hoisting",
  "error handling",
  "json",
  "design patterns",
  "concurrency",
  "algorithms",
  "sorting",
  "strings",
  "collections",
  "streams",
  "null",
  "optional",
  "hashmap",
  "oop",
  "inheritance",
  // AEM
  "aem",
  "sling-models",
  "osgi",
  "htl",
  "dispatcher",
  "oak",
  "jcr",
  "workflow",
  "spa",
  "msm",
  "cloud-service",
  "security",
  "testing",
  "clientlibs",
  "content-fragments",
  "experience-fragments",
  "graphql",
  "packages",
  "archetype",
  "replication",
  "saml",
  "ldap",
  "editable-templates",
  "core-components",
] as const;

export type TopicId = (typeof TOPIC_CATALOG)[number];

const TOPIC_SET = new Set<string>(TOPIC_CATALOG);

export function sanitizePreferredTopics(input: unknown): string[] {
  if (!Array.isArray(input)) return [];
  const out: string[] = [];
  for (const raw of input) {
    if (typeof raw !== "string") continue;
    const t = raw.trim();
    if (!TOPIC_SET.has(t)) continue;
    if (!out.includes(t)) out.push(t);
    if (out.length >= 20) break;
  }
  return out;
}
