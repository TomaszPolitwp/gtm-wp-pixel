# WP Pixel – Google Tag Manager Template

Official GTM Community Template Gallery tag for **WP Pixel** by [Wirtualna Polska](https://www.wp.pl).

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)

---

## Opis

Szablon umożliwia wdrożenie WP Pixel bezpośrednio z poziomu Google Tag Manager bez konieczności ręcznego kodowania. Obsługuje pełen zestaw eventów ecommerce zgodnych z dokumentacją pixel.wp.pl.

---

## Obsługiwane zdarzenia

| Typ zdarzenia | Wywołanie WP Pixel | Opis |
|---|---|---|
| **PageView** | `wph('track', 'ViewContent', {content_name: 'View'})` | Każda strona |
| **ProductList** | `wph('track', 'ViewContent', {content_name: 'ProductList', ...})` | Lista produktów |
| **ViewProduct** | `wph('track', 'ViewContent', {content_name: 'ViewProduct', ...})` | Strona produktu |
| **AddToCart** | `wph('track', 'AddToCart', {...})` | Dodanie do koszyka |
| **ViewCart** | `wph('track', 'ViewCart', {...})` | Wyświetlenie koszyka |
| **StartOrder** | `wph('track', 'StartOrder', {...})` | Rozpoczęcie zamówienia |
| **Purchase** | `wph('track', 'Purchase', {...})` | Zakup / transakcja |
| **RemoveFromCart** | `wph('track', 'RemoveFromCart', {...})` | Usunięcie z koszyka |
| **CartItemChange** | `wph('track', 'CartItemChange', {...})` | Zmiana produktu w koszyku |
| **AddToWishList** | `wph('track', 'ViewContent', {content_name: 'AddToWishList', ...})` | Dodanie do ulubionych |
| **RemoveFromWishList** | `wph('track', 'ViewContent', {content_name: 'RemoveFromWishList', ...})` | Usunięcie z ulubionych |
| **WishList Conversion** | `wph('track', 'Conversion', {content_name: 'WishList', ...})` | Konwersja z ulubionych |

---

## Konfiguracja w GTM

### 1. Importowanie szablonu

1. W GTM przejdź do **Szablony → Nowy** (lub **Wyszukaj w galerii**).
2. Znajdź **WP Pixel** w Community Template Gallery.
3. Dodaj szablon do obszaru roboczego.

### 2. Tworzenie tagu bazowego (PageView)

Utwórz tag typu **WP Pixel**:
- **WP Pixel ID**: wpisz swój Pixel ID (np. `12345`)
- **Typ zdarzenia**: `PageView – wszystkie strony (View)`
- **Wyzwalacz**: All Pages

### 3. Tagi ecommerce

Dla każdego zdarzenia ecommerce utwórz osobny tag. Przykład dla **AddToCart**:

- **WP Pixel ID**: `{{Constant - Pixel ID}}`
- **Typ zdarzenia**: `AddToCart – dodanie do koszyka`
- **Waluta**: `{{dlv - ecommerce.currency}}` lub `PLN`
- **Produkty (contents)**: `{{dlv - ecommerce.items}}`
- **Wyzwalacz**: Custom Event `add_to_cart`

### 4. Format tablicy produktów (contents)

```javascript
[
  {
    id: "PRODUKT_ID",
    name: "Nazwa produktu",
    category: "Kategoria",
    price: 99.99,
    quantity: 1,
    active: true
  }
]
```

### 5. Pola dla Purchase

| Pole | Opis | Przykładowa zmienna GTM |
|---|---|---|
| ID Transakcji | Unikalny ID zamówienia | `{{dlv - ecommerce.transaction_id}}` |
| Wartość netto | Wartość bez dostawy (netto) | `{{dlv - ecommerce.value}}` |
| Wartość brutto | Wartość bez dostawy (brutto) | `{{dlv - ecommerce.value_gross}}` |
| Koszt dostawy | Koszt dostawy | `{{dlv - ecommerce.shipping}}` |

---

## Zarządzanie zgodami

Domyślnie tag wywołuje `wph('go')` automatycznie po inicjalizacji.
Jeśli stosujesz własny CMP (Consent Management Platform):

1. Odznacz **Automatycznie wywołaj wph('go') po inicjalizacji**
2. Zaimplementuj wywołanie `wph('go')` / `wph('stop')` w swoim CMP

---

## Przykładowa warstwa danych (dataLayer)

### AddToCart

```javascript
dataLayer.push({
  event: 'add_to_cart',
  ecommerce: {
    currency: 'PLN',
    items: [
      {
        id: 'SKU-001',
        name: 'Laptop ASUS VivoBook',
        category: 'Laptopy',
        price: 2499.00,
        quantity: 1
      }
    ]
  }
});
```

### Purchase

```javascript
dataLayer.push({
  event: 'purchase',
  ecommerce: {
    transaction_id: 'ORDER_20240101_001',
    value: 2479.01,
    value_gross: 3049.98,
    shipping: 19.99,
    currency: 'PLN',
    items: [
      {id: 'SKU-001', name: 'Laptop ASUS VivoBook', category: 'Laptopy', price: 2499.00, quantity: 1},
      {id: 'SKU-002', name: 'Mysz Logitech MX', category: 'Akcesoria', price: 249.00, quantity: 2}
    ]
  }
});
```

---

## Wymagania

- Konto Google Tag Manager (Web container)
- Aktywny WP Pixel ID z panelu [pixel.wp.pl](https://pixel.wp.pl)
- Przesyłanie danych ecommerce do dataLayer (GA4-compatible format zalecany)

---

## Dokumentacja

- [WP Pixel – przykłady ecommerce](https://pixel.wp.pl/docs/pl/examples.html)
- [WP Pixel – integracja z GTM](https://pixel.wp.pl/docs/en/plugins/gtm.html)
- [GTM Community Template Gallery – wymagania](https://developers.google.com/tag-platform/tag-manager/templates/gallery)

---

## Licencja

[Apache License 2.0](LICENSE) © 2024 Wirtualna Polska Media S.A.
