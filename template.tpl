___INFO___

{
  "type": "TAG",
  "id": "cvt_wp_pixel_ecommerce",
  "version": 1,
  "securityGroups": [],
  "displayName": "WP Pixel",
  "categories": ["ADVERTISING", "CONVERSIONS"],
  "brand": {
    "id": "brand_wp_pixel",
    "displayName": "Wirtualna Polska"
  },
  "description": "Official WP Pixel tag for ecommerce tracking. Supports PageView, ProductList, ViewProduct, AddToCart, ViewCart, StartOrder, Purchase, RemoveFromCart, CartItemChange, AddToWishList, RemoveFromWishList and WishList Conversion events.",
  "containerContexts": ["WEB"]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "pixelId",
    "displayName": "WP Pixel ID",
    "simpleValueType": true,
    "notSetText": "Wprowadź swój WP Pixel ID",
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "WP Pixel ID jest wymagany"
      }
    ],
    "help": "Twój unikalny identyfikator WP Pixel dostępny w panelu pixel.wp.pl"
  },
  {
    "type": "SELECT",
    "name": "eventType",
    "displayName": "Typ zdarzenia",
    "macrosInSelect": false,
    "selectItems": [
      {"value": "pageView", "displayValue": "PageView – wszystkie strony (View)"},
      {"value": "productList", "displayValue": "ProductList – lista produktów"},
      {"value": "viewProduct", "displayValue": "ViewProduct – strona produktu"},
      {"value": "addToCart", "displayValue": "AddToCart – dodanie do koszyka"},
      {"value": "viewCart", "displayValue": "ViewCart – wyświetlenie koszyka"},
      {"value": "startOrder", "displayValue": "StartOrder – rozpoczęcie zamówienia"},
      {"value": "purchase", "displayValue": "Purchase – zakup / transakcja"},
      {"value": "removeFromCart", "displayValue": "RemoveFromCart – usunięcie z koszyka"},
      {"value": "cartItemChange", "displayValue": "CartItemChange – zmiana produktu w koszyku"},
      {"value": "addToWishList", "displayValue": "AddToWishList – dodanie do ulubionych"},
      {"value": "removeFromWishList", "displayValue": "RemoveFromWishList – usunięcie z ulubionych"},
      {"value": "wishListConversion", "displayValue": "WishList Conversion – konwersja z ulubionych"}
    ],
    "simpleValueType": true,
    "defaultValue": "pageView"
  },
  {
    "type": "GROUP",
    "name": "eventDataGroup",
    "displayName": "Dane zdarzenia",
    "groupStyle": "ZIPPY_OPEN",
    "visibilityConditions": [
      {"paramName": "eventType", "paramValue": "pageView", "type": "NOT_EQUALS"}
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "currency",
        "displayName": "Waluta",
        "simpleValueType": true,
        "defaultValue": "PLN",
        "help": "Kod waluty ISO 4217, np. PLN, EUR, USD",
        "valueHint": "PLN"
      },
      {
        "type": "TEXT",
        "name": "contents",
        "displayName": "Produkty (contents)",
        "simpleValueType": true,
        "help": "Zmienna GTM zawierająca tablicę produktów: [{id, name, category, price, quantity}]",
        "valueHint": "{{dlv - contents}}"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "purchaseDataGroup",
    "displayName": "Dane transakcji",
    "groupStyle": "ZIPPY_OPEN",
    "visibilityConditions": [
      {"paramName": "eventType", "paramValue": "purchase", "type": "EQUALS"}
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "transactionId",
        "displayName": "ID Transakcji",
        "simpleValueType": true,
        "help": "Unikalny identyfikator zamówienia",
        "valueHint": "{{dlv - transaction_id}}"
      },
      {
        "type": "TEXT",
        "name": "value",
        "displayName": "Wartość netto (bez kosztów dostawy)",
        "simpleValueType": true,
        "help": "Wartość netto zamówienia bez kosztów dostawy",
        "valueHint": "{{dlv - value}}"
      },
      {
        "type": "TEXT",
        "name": "valueGross",
        "displayName": "Wartość brutto (bez kosztów dostawy)",
        "simpleValueType": true,
        "help": "Wartość brutto zamówienia bez kosztów dostawy",
        "valueHint": "{{dlv - value_gross}}"
      },
      {
        "type": "TEXT",
        "name": "shippingCost",
        "displayName": "Koszt dostawy (opcjonalny)",
        "simpleValueType": true,
        "help": "Całkowity koszt dostawy",
        "valueHint": "{{dlv - shipping_cost}}"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "consentGroup",
    "displayName": "Zarządzanie zgodami",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "autoFireGo",
        "checkboxText": "Automatycznie wywołaj wph('go') po inicjalizacji",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Odznacz, jeśli zarządzasz zgodami ręcznie i sam wywołujesz wph('go') lub wph('stop')."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

var injectScript = require('injectScript');
var callInWindow = require('callInWindow');
var copyFromWindow = require('copyFromWindow');
var createArgumentsQueue = require('createArgumentsQueue');
var setInWindow = require('setInWindow');
var makeNumber = require('makeNumber');
var log = require('logToConsole');

var pixelId = data.pixelId;
var eventType = data.eventType;
var scriptUrl = 'https://pixel.wp.pl/w/' + pixelId + '/tr.js';

// ---------------------------------------------------------------------------
// 1. Setup queue (runs synchronously before the pixel script loads)
// ---------------------------------------------------------------------------
createArgumentsQueue('wph', 'queue');
setInWindow('WphTrackObject', 'wph', false);

// ---------------------------------------------------------------------------
// 2. Fire the tracking event
// ---------------------------------------------------------------------------
function fireEvent() {
  var payload = {};

  if (eventType !== 'pageView') {
    if (data.currency) payload.currency = data.currency;
    if (data.contents) payload.contents = data.contents;
  }

  if (eventType === 'pageView') {
    callInWindow('wph', 'track', 'ViewContent', {content_name: 'View'});

  } else if (eventType === 'productList') {
    payload.content_name = 'ProductList';
    callInWindow('wph', 'track', 'ViewContent', payload);

  } else if (eventType === 'viewProduct') {
    payload.content_name = 'ViewProduct';
    callInWindow('wph', 'track', 'ViewContent', payload);

  } else if (eventType === 'addToCart') {
    callInWindow('wph', 'track', 'AddToCart', payload);

  } else if (eventType === 'viewCart') {
    callInWindow('wph', 'track', 'ViewCart', payload);

  } else if (eventType === 'startOrder') {
    callInWindow('wph', 'track', 'StartOrder', payload);

  } else if (eventType === 'purchase') {
    if (data.transactionId) payload.transaction_id = data.transactionId;
    if (data.value !== undefined && data.value !== '') {
      payload.value = makeNumber(data.value);
    }
    if (data.valueGross !== undefined && data.valueGross !== '') {
      payload.value_gross = makeNumber(data.valueGross);
    }
    if (data.shippingCost !== undefined && data.shippingCost !== '') {
      payload.shipping_cost = makeNumber(data.shippingCost);
    }
    callInWindow('wph', 'track', 'Purchase', payload);

  } else if (eventType === 'removeFromCart') {
    callInWindow('wph', 'track', 'RemoveFromCart', payload);

  } else if (eventType === 'cartItemChange') {
    callInWindow('wph', 'track', 'CartItemChange', payload);

  } else if (eventType === 'addToWishList') {
    payload.content_name = 'AddToWishList';
    callInWindow('wph', 'track', 'ViewContent', payload);

  } else if (eventType === 'removeFromWishList') {
    payload.content_name = 'RemoveFromWishList';
    callInWindow('wph', 'track', 'ViewContent', payload);

  } else if (eventType === 'wishListConversion') {
    payload.content_name = 'WishList';
    callInWindow('wph', 'track', 'Conversion', payload);
  }
}

// ---------------------------------------------------------------------------
// 3. Init pixel once per page, then fire the event
// ---------------------------------------------------------------------------
var alreadyInitialized = copyFromWindow('_wphGtmInitialized');

if (!alreadyInitialized) {
  setInWindow('_wphGtmInitialized', true, true);
  callInWindow('wph', 'init', pixelId);

  if (data.autoFireGo !== false) {
    callInWindow('wph', 'go');
  }

  injectScript(scriptUrl, function() {
    log('[WP Pixel] Script loaded. Firing event:', eventType);
    fireEvent();
    data.gtmOnSuccess();
  }, data.gtmOnFailure, scriptUrl);

} else {
  log('[WP Pixel] Already initialized. Firing event:', eventType);
  fireEvent();
  data.gtmOnSuccess();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {"publicId": "inject_script", "versionId": "1"},
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [{"type": 1, "string": "https://pixel.wp.pl/"}]
          }
        }
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "access_globals", "versionId": "1"},
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [{"type": 1, "string": "key"}, {"type": 1, "string": "read"}, {"type": 1, "string": "write"}, {"type": 1, "string": "execute"}],
                "mapValue": [{"type": 1, "string": "wph"}, {"type": 8, "boolean": true}, {"type": 8, "boolean": true}, {"type": 8, "boolean": true}]
              },
              {
                "type": 3,
                "mapKey": [{"type": 1, "string": "key"}, {"type": 1, "string": "read"}, {"type": 1, "string": "write"}, {"type": 1, "string": "execute"}],
                "mapValue": [{"type": 1, "string": "wph.queue"}, {"type": 8, "boolean": true}, {"type": 8, "boolean": true}, {"type": 8, "boolean": false}]
              },
              {
                "type": 3,
                "mapKey": [{"type": 1, "string": "key"}, {"type": 1, "string": "read"}, {"type": 1, "string": "write"}, {"type": 1, "string": "execute"}],
                "mapValue": [{"type": 1, "string": "WphTrackObject"}, {"type": 8, "boolean": true}, {"type": 8, "boolean": true}, {"type": 8, "boolean": false}]
              },
              {
                "type": 3,
                "mapKey": [{"type": 1, "string": "key"}, {"type": 1, "string": "read"}, {"type": 1, "string": "write"}, {"type": 1, "string": "execute"}],
                "mapValue": [{"type": 1, "string": "_wphGtmInitialized"}, {"type": 8, "boolean": true}, {"type": 8, "boolean": true}, {"type": 8, "boolean": false}]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {"isEditedByUser": true},
    "isRequired": true
  },
  {
    "instance": {
      "key": {"publicId": "logging", "versionId": "1"},
      "param": [{"key": "environments", "value": {"type": 1, "string": "debug"}}]
    },
    "isRequired": true
  }
]


___TESTS___

const mockData = {
  pixelId: 'TEST_PIXEL_123',
  eventType: 'purchase',
  currency: 'PLN',
  contents: [
    {id: 'prod_001', name: 'Laptop XYZ', category: 'Electronics', price: 2499.00, quantity: 1},
    {id: 'prod_002', name: 'Mysz bezprzewodowa', category: 'Accessories', price: 129.00, quantity: 2}
  ],
  transactionId: 'ORDER_20240101_001',
  value: 2757.00,
  valueGross: 3391.11,
  shippingCost: 19.99,
  autoFireGo: true,
  gtmOnSuccess: () => {},
  gtmOnFailure: () => {}
};

mock('injectScript', (url, onSuccess) => { onSuccess(); });
mock('callInWindow', () => {});
mock('copyFromWindow', () => false);
mock('setInWindow', () => {});
mock('createArgumentsQueue', () => {});
mock('makeNumber', (v) => Number(v));
mock('logToConsole', () => {});

runCode(mockData);

assertApi('gtmOnSuccess').wasCalled();
assertApi('injectScript').wasCalled();


___NOTES___

WP Pixel GTM Template – official community template for Google Tag Manager.

Supported events:
  • PageView      → wph('track', 'ViewContent', {content_name: 'View'})
  • ProductList   → wph('track', 'ViewContent', {content_name: 'ProductList', ...})
  • ViewProduct   → wph('track', 'ViewContent', {content_name: 'ViewProduct', ...})
  • AddToCart     → wph('track', 'AddToCart', {...})
  • ViewCart      → wph('track', 'ViewCart', {...})
  • StartOrder    → wph('track', 'StartOrder', {...})
  • Purchase      → wph('track', 'Purchase', {transaction_id, value, value_gross, shipping_cost, ...})
  • RemoveFromCart → wph('track', 'RemoveFromCart', {...})
  • CartItemChange → wph('track', 'CartItemChange', {...})
  • AddToWishList → wph('track', 'ViewContent', {content_name: 'AddToWishList', ...})
  • RemoveFromWishList → wph('track', 'ViewContent', {content_name: 'RemoveFromWishList', ...})
  • WishList Conversion → wph('track', 'Conversion', {content_name: 'WishList', ...})

Docs: https://pixel.wp.pl/docs/
