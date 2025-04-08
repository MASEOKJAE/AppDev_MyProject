# 📚 열람실 사석화 방지 시스템 (Hot Spot)
aa
> Flutter 기반으로 개발된 **실시간 좌석 정보 제공 & 사석화 방지 앱**
> 
> Firebase 기반의 인증 및 데이터 관리, 다양한 유틸리티 기능 탑재

<img width="336" alt="image" src="https://github.com/user-attachments/assets/89c98f86-f37f-46d3-be3c-49e9c577a5b9">

---

## 1️⃣ 문제 정의

시험 기간마다 반복되는 열람실 "사석화" 문제는 학생들의 학습 효율을 심각하게 저해합니다. 자리를 차지해놓고 사용하지 않는 좌석으로 인해 실제 자리가 부족해지는 문제를 해결하고자 본 앱을 기획했습니다.

- 실시간 열람실 좌석 정보 제공
- 사용자 좌석 점유 여부 확인 및 공유
- 다양한 학습 지원 기능 내장 (동기부여 영상, 나침반 안내 등)

---

## 2️⃣ 초기 화면 설계

- 구글 로그인과 AppBar 사용

    <img width="200" alt="image" src="https://github.com/user-attachments/assets/f57b2012-ec3e-4d68-9bdc-1556cc1893b9"> <img width="200" alt="image" src="https://github.com/user-attachments/assets/a7537223-faef-4eee-8aa0-76cb94ab1070">
- 사용자 정보 및 업적 관리

  <img width="200" alt="image" src="https://github.com/user-attachments/assets/d37ef137-13b5-43e9-aed7-380b1b3bf31a"> <img width="200" alt="image" src="https://github.com/user-attachments/assets/11515284-387d-4158-9181-d068463a970d">


- 도서관 자리 예약 및 정보 확인

  <img width="200" alt="image" src="https://github.com/user-attachments/assets/5b0e9dea-40e4-4de8-857a-ef279993f311"> <img width="200" alt="image" src="https://github.com/user-attachments/assets/03fc30f4-ff43-4ade-9721-5e05f6e189d2">


---

## 3️⃣ 상태 관리 설계 (`provider`)

[🔗 Provider 공식 문서](https://pub.dev/packages/provider)

`provider`는 앱 전체에서 열람실 좌석 데이터를 효율적으로 공유하고, 실시간 변경사항을 반영하기 위해 사용됩니다. Firebase를 반복 조회하지 않고, 메모리에 저장된 상태로 앱 성능과 반응성을 향상시켰습니다.

---

## 4️⃣ Firebase Database 설계

```
├── users/
│   └── {uid}/
│       ├── email, name, message, uid
│       └── favorite/
│           └── {room_name}/
│               └── {seat_index}: true
├── rooms/
│   └── {room_name}/
│       └── seats/
│           └── {seat_index}/
│               ├── email: user_email
│               └── status: occupied | available
```

### 📁 users Collection
<img width="400" alt="image" src="https://github.com/user-attachments/assets/2087764f-658c-46e6-859c-769847aae5a6">

- 각 사용자 계정 정보를 저장하는 최상위 컬렉션입니다.
- `{uid}`를 문서 ID로 사용하며, 해당 사용자에 대한 `email`, `name`, `message`, `uid` 등의 로그인 정보가 저장됩니다.

### ⭐ favorite Subcollection
<img width="400" alt="image" src="https://github.com/user-attachments/assets/46450739-e844-401e-b358-357defbb55ae">

- 각 사용자(`{uid}`) 문서 내에 존재하는 서브컬렉션입니다.
- 사용자가 즐겨찾기한 좌석 정보를 `room_name` → `seat_index` 형식으로 트리 구조처럼 저장합니다.
- 즐겨찾는 좌석을 효율적으로 빠르게 불러오기 위해 최적화된 형태로 설계되었습니다.

### 📁 rooms Collection
<img width="400" alt="image" src="https://github.com/user-attachments/assets/fb79076c-6e17-4748-a843-c021c1375958">

- 열람실 정보를 저장하는 컬렉션입니다.
- 각 `room_name` 별 문서가 존재하며, 그 내부에 `seats` 컬렉션이 포함됩니다.

### 💺 seats Subcollection
<img width="400" alt="image" src="https://github.com/user-attachments/assets/aa608a72-3259-422b-bb6b-92a3249e7bf3">

- 실제 열람실 내 각 좌석에 대한 정보가 문서로 구성되어 있습니다.
- 각 `seat_index`는 문서 ID로 사용되며, `email` 필드는 해당 좌석을 사용 중인 학생의 이메일을 의미합니다.
- `status` 필드는 좌석의 현재 상태 (`occupied`, `available`)를 나타냅니다.

> 🔄 이 구조를 기반으로 앱에서는 실시간 좌석 상태 조회, 상태 변경, 즐겨찾기 기능 등을 효율적으로 구현할 수 있습니다.

---

## 5️⃣ 프로젝트 내 사용된 주요 패키지 & API 정리

### 🔐 로그인 / UI 관련
<img width="150" alt="image" src="https://github.com/user-attachments/assets/0580ee5d-6ed9-4fb1-bc0f-aeeb068fb192">

| 패키지 | 설명 | 링크 |
|--------|------|------|
| google_sign_in | Google 계정 로그인 | [바로가기](https://pub.dev/packages/google_sign_in) |
| firebase_auth | Firebase 인증 기능 | [바로가기](https://pub.dev/packages/firebase_auth) |
| firebase_core | Firebase SDK 초기화 | [바로가기](https://pub.dev/packages/firebase_core) |
| cached_network_image | 네트워크 이미지 캐싱 | [바로가기](https://pub.dev/packages/cached_network_image) |
| flutter_svg | SVG 이미지 렌더링 | [바로가기](https://pub.dev/packages/flutter_svg) |


### ☁️ 데이터베이스 및 상태관리
<img width="150" alt="image" src="https://github.com/user-attachments/assets/918fa0ee-d012-4938-9055-6865953267b8">

| 패키지 | 설명 | 링크 |
|--------|------|------|
| cloud_firestore | Firebase 실시간 NoSQL DB | [바로가기](https://pub.dev/packages/cloud_firestore) |
| provider | 상태관리 도구 | [바로가기](https://pub.dev/packages/provider) |
| shared_preferences | 로컬 데이터 저장 | [바로가기](https://pub.dev/packages/shared_preferences) |
| rxdart | 스트림 기반 반응형 처리 | [바로가기](https://pub.dev/packages/rxdart) |

### ⏰ 알림 및 타이머
<img width="150" alt="image" src="https://github.com/user-attachments/assets/790ea4f9-5eb9-4ce0-bfe9-aa390113f50f">

| 패키지 | 설명 | 링크 |
|--------|------|------|
| flutter_local_notifications | 로컬 알림 기능 | [바로가기](https://pub.dev/packages/flutter_local_notifications) |
| timezone | 시간대 관리 기능 | [바로가기](https://pub.dev/packages/timezone) |

### 📺 동영상 및 외부 API
<img width="150" alt="image" src="https://github.com/user-attachments/assets/07da1d87-6595-4b4b-a8aa-68c3ac8bb025">

| 패키지 | 설명 | 링크 |
|--------|------|------|
| youtube_player_flutter | YouTube 영상 재생 | [바로가기](https://pub.dev/packages/youtube_player_flutter) |
| http | HTTP 요청 처리 (YouTube Data API) | [바로가기](https://pub.dev/packages/http) |

### 📍 위치 / 나침반
<img width="150" alt="image" src="https://github.com/user-attachments/assets/cb3c7a5f-d22f-45a0-98fc-0a3cf0498fdd">

| 패키지 | 설명 | 링크 |
|--------|------|------|
| location | 위치 정보 접근 | [바로가기](https://pub.dev/packages/location) |
| permission_handler | 권한 요청 처리 | [바로가기](https://pub.dev/packages/permission_handler) |
| flutter_compass | 나침반 방향 감지 | [바로가기](https://pub.dev/packages/flutter_compass) |
| math | 수학 계산 (나침반 회전) | [바로가기](https://api.dart.dev/stable/3.2.1/dart-math/dart-math-library.html) |

---

## 6️⃣ 주요 결과물 & 기능 소개

### 🔐 Login Page
<img width="150" alt="image" src="https://github.com/user-attachments/assets/a32a2e44-d69a-4332-86f1-3b8f20c2f4d9">

Google 로그인 → Home Page 이동, SVG 로고 렌더링 적용
> 사용 API: `google_sign_in`, `firebase_auth`, `flutter_svg`

### 🏠 Home Page
<img width="150" alt="image" src="https://github.com/user-attachments/assets/83c90d76-2f22-48b5-9043-4430634c9681">

전체 열람실 요약 + Drawer 접근
> 사용 API: `provider`, `cloud_firestore`

### 🍔 Drawer Menu
<img width="150" alt="image" src="https://github.com/user-attachments/assets/07459561-1ceb-4f71-b503-7a2530dcae2b">

기능별 페이지 라우팅 (홈 / 즐겨찾기 / 프로필 / 동기부여 / 설정)

### ⭐ Favorites Page
<img width="150" alt="image" src="https://github.com/user-attachments/assets/1131e5e8-6a7c-434e-bc1a-c91976823246">

즐겨찾기한 좌석 리스트뷰 표시
> 사용 API: `cloud_firestore`, `provider`

### 🪑 열람실 상세 Page
<img width="150" alt="image" src="https://github.com/user-attachments/assets/1aa19754-5153-4279-9048-1259943463dd"> <img width="150" alt="image" src="https://github.com/user-attachments/assets/aaf2e6b9-d51a-43ea-874b-a916c564c9e3"> <img width="150" alt="image" src="https://github.com/user-attachments/assets/410cc7dc-20c4-43e5-8d59-0d7f8a24536a"> <img width="150" alt="image" src="https://github.com/user-attachments/assets/68fe95a4-0cc0-45f6-81b8-b4c4cc24f5f8"> <img width="150" alt="image" src="https://github.com/user-attachments/assets/e6417384-af44-40e0-9cce-3e7233e37d39">

좌석 상태 실시간 확인 (🟥 사용 중 / 🟩 사용 가능), 상태 변경 버튼 노출
> 사용 API: `cloud_firestore`, `provider`

### 👤 My Page
<img width="150" alt="image" src="https://github.com/user-attachments/assets/68a7e32d-5598-458f-8cd9-f299c6f43a44">

유저 프로필 및 GPS 버튼, 설정 진입
> 사용 API: `shared_preferences`, `location`

### 🧭 Location Tracker
<img width="150" alt="image" src="https://github.com/user-attachments/assets/0f5b465d-4d3c-4399-a878-4ff58f919d3f">

사용자 위치 → 오석관 방향 안내, 나침반 회전
> 사용 API: `location`, `flutter_compass`, `math`, `permission_handler`

### ⏱ Motivation Page (1)
<img width="150" alt="image" src="https://github.com/user-attachments/assets/a4530dde-2dbe-4a77-b504-09e7741366be">

공부 시간 예약 → 알림 & 스톱워치 기능
> 사용 API: `flutter_local_notifications`, `timezone`, `shared_preferences`

### 📺 Motivation Page (2)
<img width="150" alt="image" src="https://github.com/user-attachments/assets/749461a4-3c17-48a3-903d-5ac9fa4193f6">

실시간 유튜브 동영상 조회 및 재생
> 사용 API: `http`, `youtube_player_flutter`

### ⚙️ Setting Page
<img width="150" alt="image" src="https://github.com/user-attachments/assets/6d7698bf-2ea7-4af2-b45e-41d5a9580620">

로그아웃 및 이용 약관 확인 기능

---

## 7️⃣ 개발 로드맵

| 버전 | 기능 |
|------|------|
| v1.5 | UI 개선, 다크 모드, 약관 추가 |
| v2.0 | 업적 / 경고 기능, 좌석 이력 조회 |
| v3.0 | QR 좌석 체크 기능, 버그 리포트 시스템 |

---

## 8️⃣ 팀원 & 소감

| 이름 | 역할 |
|------|------|
| 마석재 | 팀장, 전체 로직 & UI, Firebase 구조 설계, Provider 상태관리, 알림 구현 |
| 이희준 | YouTube API, GPS + 나침반 기능 구현 |

### 💬 마석재
> 다양한 API와 외부 패키지의 활용을 통해 Flutter 개발 접근법의 폭을 넓혔습니다. 협업 과정에서의 소통 능력, 구조 설계 역량을 성장시킨 뜻깊은 프로젝트였습니다.

### 💬 이희준
> Flutter의 확장성과 도전 의식을 체득할 수 있었습니다.

---

## 📺 시연 영상

[▶️ YouTube 시연 영상 보기](https://youtu.be/gurSl48UsJw)

---

## 📜 참고 고지

- 나침반 기능 구현은 `flutter_compass` 예제 코드를 기반으로 수정하여 사용하였습니다.  
  [참고 링크](https://pub.dev/packages/flutter_compass/example)

---
