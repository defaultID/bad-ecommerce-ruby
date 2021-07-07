import TomSelect from 'tom-select/dist/esm/tom-select';

function onLoad() {
  new TomSelect('#user_country_code', {
    allowEmptyOption: true,
    create: false
  });
}

export default function init() {
  document.addEventListener('DOMContentLoaded', onLoad, false);
}
