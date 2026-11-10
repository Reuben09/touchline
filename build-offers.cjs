const fs = require('node:fs');
global.window = {};
require('./dist/offers.js');

const template = fs.readFileSync('dist/index.html', 'utf8');
const escape = value => value.replace(/[&<>"']/g, char => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[char]));
const slugs = new Set();
fs.mkdirSync('dist/offers', {recursive:true});
for (const offer of window.TOUCHLINE_SAMPLE) {
  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(offer.slug) || slugs.has(offer.slug)) throw new Error('Invalid or duplicate slug: ' + offer.slug);
  slugs.add(offer.slug);
  const title = escape(offer.title);
  const main = `<main class="shell offer-page"><a class="back" href="../index.html#offers">← All offers</a>
<section class="hero"><div class="pitch" aria-hidden="true"><i></i></div><div class="hero-content"><p class="eyebrow"><span></span> ${escape(offer.category)} · DEMO OFFER</p><h1>${title}</h1><p class="reward">${escape(offer.value)}</p></div></section>
<section class="terms" aria-labelledby="terms-title"><h2 id="terms-title">Rules &amp; terms</h2><ol>${offer.rules.map(rule => '<li>' + escape(rule) + '</li>').join('')}</ol><p>18+ and verified accounts only. Unless stated otherwise, cash-outs, void bets and bonus stakes do not qualify. Free-bet stakes are excluded from returns.</p></section></main>`;
  const page = template.replace('Bonus Hub | Touchline', () => title + ' | Touchline')
    .replace('href="style.css"', 'href="../style.css"')
    .replace(/<script defer[^>]*><\/script>/g, '')
    .replaceAll('href="#"', 'href="../index.html"')
    .replace('href="#offers"', 'href="../index.html#offers"')
    .replace(/<main[\s\S]*?<\/main>/, () => main);
  fs.writeFileSync('dist/offers/' + offer.slug + '.html', page);
}
for (const file of fs.readdirSync('dist/offers')) {
  if (file.endsWith('.html') && !slugs.has(file.slice(0, -5))) fs.unlinkSync('dist/offers/' + file);
}
