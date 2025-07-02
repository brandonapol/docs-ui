---
title: API Reference
description: Complete API reference with examples and detailed documentation for all endpoints.
category: reference
createdAt: 2025-01-01T02:00:00.000Z
---

# API Reference

Complete reference for all available API endpoints, including request/response examples and authentication details.

## Authentication

All API requests require authentication using an API key. Include your API key in the request headers:

```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
     -H "Content-Type: application/json" \
     https://api.example.com/v1/endpoint
```

### Authentication Headers

| Header | Value |
|--------|-------|
| `Authorization` | `Bearer YOUR_API_KEY` |
| `Content-Type` | `application/json` |

## Base URL

All API endpoints are relative to the base URL:

```
https://api.example.com/v1
```

## Rate Limiting

API requests are limited to:
- **Free tier**: 100 requests per hour
- **Pro tier**: 1,000 requests per hour
- **Enterprise**: 10,000 requests per hour

## Users

### Get User Profile

Retrieve the current user's profile information.

**Endpoint:** `GET /users/me`

**Request:**
```javascript
const response = await fetch('https://api.example.com/v1/users/me', {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  }
});

const user = await response.json();
```

**Response:**
```json
{
  "id": "user_123",
  "email": "user@example.com",
  "name": "John Doe",
  "created_at": "2025-01-01T00:00:00Z",
  "subscription": {
    "plan": "pro",
    "status": "active"
  }
}
```

### Update User Profile

Update the current user's profile information.

**Endpoint:** `PUT /users/me`

**Request:**
```javascript
const response = await fetch('https://api.example.com/v1/users/me', {
  method: 'PUT',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    name: 'Jane Doe',
    email: 'jane@example.com'
  })
});
```

**Response:**
```json
{
  "id": "user_123",
  "email": "jane@example.com",
  "name": "Jane Doe",
  "updated_at": "2025-01-01T12:00:00Z"
}
```

## Documents

### List Documents

Retrieve a list of all documents with optional filtering and pagination.

**Endpoint:** `GET /documents`

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `page` | integer | Page number (default: 1) |
| `limit` | integer | Items per page (default: 20, max: 100) |
| `search` | string | Search query |
| `category` | string | Filter by category |
| `status` | string | Filter by status (draft, published, archived) |

**Request:**
```javascript
const params = new URLSearchParams({
  page: '1',
  limit: '10',
  search: 'api',
  category: 'reference'
});

const response = await fetch(`https://api.example.com/v1/documents?${params}`, {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY'
  }
});

const documents = await response.json();
```

**Response:**
```json
{
  "data": [
    {
      "id": "doc_123",
      "title": "API Documentation",
      "slug": "api-documentation",
      "category": "reference",
      "status": "published",
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-01T12:00:00Z",
      "author": {
        "id": "user_456",
        "name": "Technical Writer"
      }
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 10,
    "total": 50,
    "pages": 5
  }
}
```

### Get Document

Retrieve a specific document by ID.

**Endpoint:** `GET /documents/{id}`

**Request:**
```javascript
const response = await fetch('https://api.example.com/v1/documents/doc_123', {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY'
  }
});

const document = await response.json();
```

**Response:**
```json
{
  "id": "doc_123",
  "title": "API Documentation",
  "slug": "api-documentation",
  "content": "# API Documentation\n\nThis is the content...",
  "category": "reference",
  "status": "published",
  "tags": ["api", "reference", "documentation"],
  "created_at": "2025-01-01T00:00:00Z",
  "updated_at": "2025-01-01T12:00:00Z",
  "author": {
    "id": "user_456",
    "name": "Technical Writer",
    "email": "writer@example.com"
  }
}
```

### Create Document

Create a new document.

**Endpoint:** `POST /documents`

**Request:**
```javascript
const response = await fetch('https://api.example.com/v1/documents', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    title: 'New Document',
    content: '# New Document\n\nThis is a new document.',
    category: 'guide',
    status: 'draft',
    tags: ['new', 'guide']
  })
});

const document = await response.json();
```

### Update Document

Update an existing document.

**Endpoint:** `PUT /documents/{id}`

**Request:**
```javascript
const response = await fetch('https://api.example.com/v1/documents/doc_123', {
  method: 'PUT',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    title: 'Updated Document Title',
    content: '# Updated Content\n\nThis is updated content.',
    status: 'published'
  })
});
```

### Delete Document

Delete a document permanently.

**Endpoint:** `DELETE /documents/{id}`

**Request:**
```javascript
const response = await fetch('https://api.example.com/v1/documents/doc_123', {
  method: 'DELETE',
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY'
  }
});

// Returns 204 No Content on success
```

## Search

### Search Documents

Perform a full-text search across all documents.

**Endpoint:** `GET /search`

**Query Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `q` | string | Search query (required) |
| `category` | string | Filter by category |
| `limit` | integer | Number of results (default: 10, max: 50) |

**Request:**
```javascript
const params = new URLSearchParams({
  q: 'authentication api',
  category: 'reference',
  limit: '5'
});

const response = await fetch(`https://api.example.com/v1/search?${params}`, {
  headers: {
    'Authorization': 'Bearer YOUR_API_KEY'
  }
});

const results = await response.json();
```

**Response:**
```json
{
  "query": "authentication api",
  "results": [
    {
      "id": "doc_123",
      "title": "API Authentication",
      "slug": "api-authentication",
      "excerpt": "Learn how to authenticate with our API using tokens...",
      "category": "reference",
      "score": 0.95,
      "highlights": [
        "API <mark>authentication</mark> using tokens",
        "Bearer token <mark>API</mark> requests"
      ]
    }
  ],
  "total": 1,
  "took": 25
}
```

## Error Handling

All API endpoints return standard HTTP status codes and error responses.

### Error Response Format

```json
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "The request is invalid or missing required parameters",
    "details": {
      "field": "email",
      "issue": "Email address is required"
    }
  }
}
```

### Common Error Codes

| Status Code | Error Code | Description |
|-------------|------------|-------------|
| 400 | `INVALID_REQUEST` | Request is malformed or missing parameters |
| 401 | `UNAUTHORIZED` | API key is missing or invalid |
| 403 | `FORBIDDEN` | Access denied for this resource |
| 404 | `NOT_FOUND` | Resource not found |
| 429 | `RATE_LIMITED` | Too many requests |
| 500 | `INTERNAL_ERROR` | Server error |

## SDKs and Libraries

We provide official SDKs for popular programming languages:

- **JavaScript/Node.js**: `npm install @example/api-client`
- **Python**: `pip install example-api-client`
- **PHP**: `composer require example/api-client`
- **Ruby**: `gem install example-api-client`

### JavaScript SDK Example

```javascript
import { ExampleAPI } from '@example/api-client';

const api = new ExampleAPI('YOUR_API_KEY');

// Get user profile
const user = await api.users.me();

// List documents
const documents = await api.documents.list({
  category: 'reference',
  limit: 10
});

// Search
const results = await api.search('authentication');
```

## Webhooks

Configure webhooks to receive real-time notifications about events.

### Webhook Events

| Event | Description |
|-------|-------------|
| `document.created` | New document created |
| `document.updated` | Document updated |
| `document.deleted` | Document deleted |
| `user.created` | New user registered |

### Webhook Payload Example

```json
{
  "event": "document.created",
  "timestamp": "2025-01-01T12:00:00Z",
  "data": {
    "id": "doc_123",
    "title": "New Document",
    "author_id": "user_456"
  }
}
```

Need more help? Check out our [Advanced Features](/advanced-features) guide or [Troubleshooting](/troubleshooting) section. 