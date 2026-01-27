export default {
  async fetch(request) {
    const url = new URL(request.url);
    const base = 'https://yemanenigussecrc2026.z13.web.core.windows.net'
    const wantsHTML = 
        request.method === "GET" &&
        (request.headers.get("Accept") || "").includes("text/html");
    
    // Try to fetch the request path first (good for direct deep links)
    const upstreamUrl = `${base}${url.pathname}${url.search}`;
    let upstreamResp = await fetch(upstreamUrl, new Request(request, { redirect: "follow" }));
    
    if (upstreamResp.status !== 404) {
      // Pass Through but improve caching for hashed assets
      const headers = new Headers(upstreamResp.headers);
      if (url.pathname.startsWith("/assets/")) {
        // long cache for fingerprinted assets
        headers.set("Cache-Control", "public, max-age=31536000, immutable");
      }
      return new Response(upstreamResp.body, {
        status: upstreamResp.status,
        statusText: upstreamResp.statusText,
        headers, 
      });
    }
    // If its an SPA route (or you want universal fallback), serve index.html
    if (wantsHTML) {
      const indexUrl = `${base}/index.html`;
      const indexResp = await fetch(indexUrl, new Request(request, { redirect: "follow" }));
      const newHeaders = new Headers(indexResp.headers);
      newHeaders.set("Cache-Control", "public, max-age=300");
      newHeaders.set("Content-Type", "text/html; charset=utf-8");
      return new Response(indexResp.body, {
          status: indexResp.status,
          statusText: indexResp.statusText,
          headers: newHeaders
      });
    }
    // Not eHTML: preserve 404 for other requests
    return upstreamResp;
  },
}