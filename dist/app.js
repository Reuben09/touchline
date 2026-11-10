const list = document.querySelector('#list');
const statusLine = document.querySelector('#status');
const filters = document.querySelector('#filters');
const query = document.querySelector('#query');
const allCategories = 'All offers';
let offers = [];
let category = allCategories;
let mode = '';

function element(tag, text, className) {
  const node = document.createElement(tag);
  if (text !== undefined) node.textContent = text;
  if (className) node.className = className;
  return node;
}

function offerCard(offer) {
  const card = element('a', undefined, 'offer-card');
  card.href = 'offers/' + encodeURIComponent(offer.slug) + '.html';
  const label = element('span');
  label.append(element('span', offer.title, 'offer-title'), element('span', offer.category, 'category'));
  const arrow = element('span', '→', 'arrow');
  arrow.setAttribute('aria-hidden', 'true');
  card.append(element('span', String(offers.indexOf(offer) + 1).padStart(2, '0'), 'number'), label, element('span', offer.value, 'value'), arrow);
  return card;
}

function render() {
  const term = query.value.trim().toLowerCase();
  const shown = offers.filter(offer => {
    const searchable = [offer.title, offer.category, offer.value, ...offer.rules].join(' ').toLowerCase();
    return (category === allCategories || offer.category === category) && searchable.includes(term);
  });
  for (const button of filters.children) button.setAttribute('aria-pressed', String(button.textContent === category));
  statusLine.textContent = shown.length + (shown.length === 1 ? ' offer' : ' offers') + mode;
  list.replaceChildren(...shown.map(offerCard));
  if (!shown.length) list.append(element('p', 'No offers match this view.'));
}

function show(rows, label) {
  offers = rows;
  mode = label;
  const categories = [allCategories, ...new Set(rows.map(offer => offer.category))];
  filters.replaceChildren(...categories.map(name => {
    const button = element('button', name);
    button.type = 'button';
    button.addEventListener('click', () => { category = name; render(); });
    return button;
  }));
  render();
}


query.addEventListener('input', render);
show(window.TOUCHLINE_SAMPLE, ' · Demo offers');

