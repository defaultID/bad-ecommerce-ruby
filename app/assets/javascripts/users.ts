import TomSelect from 'tom-select/dist/esm/tom-select';

function onLoad() {
  const countrySelect = document.querySelector('body.users #user_country_code');

  if (countrySelect) {
    // eslint-disable-next-line no-new
    new TomSelect(countrySelect, {
      allowEmptyOption: true,
      create: false,
    });
  }
}

export default function init() {
  document.addEventListener('DOMContentLoaded', onLoad, false);
}
