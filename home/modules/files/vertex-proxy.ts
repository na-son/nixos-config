// Vertex AI passthrough plugin for opencode.
//
// Mints a fresh identity token via `gcloud auth print-identity-token` and
// injects it as the Authorization header on requests the
// @ai-sdk/google-vertex/anthropic provider makes. Rewrites the request host
// to the provider's `options.proxyURL` (set in opencode.json) when present.

let proxyURL: string | undefined;
let cachedToken: { token: string; expiresAt: number } | null = null;

async function getIdentityToken(): Promise<string> {
  if (cachedToken && cachedToken.expiresAt > Date.now() + 5 * 60 * 1000) {
    return cachedToken.token;
  }
  const token = (await Bun.$`gcloud auth print-identity-token`.text()).trim();
  const payload = JSON.parse(atob(token.split(".")[1]));
  cachedToken = { token, expiresAt: payload.exp * 1000 };
  return token;
}

async function vertexProxyFetch(
  input: RequestInfo | URL,
  init?: RequestInit,
): Promise<Response> {
  const token = await getIdentityToken();
  const url = new URL(typeof input === "string" ? input : input.toString());

  if (proxyURL && url.hostname.endsWith("-aiplatform.googleapis.com")) {
    const o = new URL(proxyURL);
    url.protocol = o.protocol;
    url.hostname = o.hostname;
    url.port = o.port;
  }

  const headers = new Headers(init?.headers);
  headers.set("Authorization", `Bearer ${token}`);
  return globalThis.fetch(url.toString(), { ...init, headers });
}

export default async () => ({
  config: async (config: any) => {
    const vp = config.provider?.["vertex-anthropic"];
    if (vp) {
      vp.options = vp.options || {};
      vp.options.project =
        process.env.ANTHROPIC_VERTEX_PROJECT_ID || vp.options.project;
      vp.options.location =
        process.env.CLOUD_ML_REGION || vp.options.location;
      proxyURL = vp.options.proxyURL?.replace(/\/v1\/?$|\/$/, "");
      delete vp.options.proxyURL;
      vp.options.fetch = vertexProxyFetch;
    }
  },
});
