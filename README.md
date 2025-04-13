# hummingbird

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

datasource
데이터 소스(외부 API, 로컬 데이터베이스 등)와 관련된 코드를 포함합니다.
(예: REST API 호출, Hive, Firebase, GraphQL 등)

models
애플리케이션의 데이터 구조를 정의하는 파일들이 들어있습니다.
(예: User, Post, Task 등과 같은 엔티티 클래스)

providers
Riverpod을 활용한 상태 관리 관련 코드가 포함됩니다.
(예: StateNotifierProvider, FutureProvider 등)

repositories
데이터 소스와 비즈니스 로직을 중개하는 계층입니다.
데이터 호출 로직을 캡슐화하여 ViewModel 또는 Provider가 데이터를 쉽게 활용하도록 돕습니다.

viewmodels
MVVM 패턴에서 View와 Repository를 연결하는 로직을 포함합니다.
상태 관리를 포함한 UI 로직이 여기에 위치합니다.
(예: StateNotifierProvider, FutureProvider 등)

다국어 지원 파일 목록 정리

ar.json 아랍어
da.json 덴마크어
de.json 독일어
en.json 영어
es.json 스페인어
fr.json 프랑스어
hi.json 힌디어
it.json 이태리어
ja.json 일본어
ko.json 한국어
ru.json 러시아어
th.json 태국어
vi.json 베트남어
zh.json 중국어

## Analytics 로그

### 현재 로깅되는 이벤트

1. **페이지 이동 이벤트 (`page_navigation`)**

   - 발생 위치: `router.dart`의 페이지 전환 시
   - 파라미터:
     - `from_page`: 이전 페이지 경로 (예: `/home`, `/social`)
     - `to_page`: 이동한 페이지 경로
     - `timestamp`: 이벤트 발생 시간 (ISO 8601 형식)

2. **화면 조회 이벤트 (`screen_view`)**

   - 발생 위치: `router.dart`의 화면 전환 시
   - 파라미터:
     - `screen_name`: 화면 이름 (예: `HomeScreen`, `SocialScreen`)
     - `screen_class`: 화면 클래스 이름
     - `timestamp`: 이벤트 발생 시간

3. **타이머 관련 이벤트**

   - 타이머 시작 (`timer_start`)

     - 발생 위치: `SuduckTimerFocusModeWidget` 초기화 시
     - 파라미터:
       - `timer_type`: 타이머 종류 (현재 `focus_mode`만 사용)
       - `timestamp`: 이벤트 발생 시간

   - 타이머 저장 (`timer_save`)
     - 발생 위치: `SuduckTimerFocusModeWidget`의 `_saveTimerData` 메서드
     - 파라미터:
       - `timer_type`: 타이머 종류 (`focus_mode`)
       - `duration`: 타이머 지속 시간 (초 단위)
       - `timestamp`: 이벤트 발생 시간

4. **인증 관련 이벤트**

   - 로그인 (`login`)

     - 발생 위치: `AuthProvider`의 로그인 메서드
     - 파라미터:
       - `login_method`: 로그인 방법 (`google`, `apple`)
       - `timestamp`: 이벤트 발생 시간

   - 회원가입 (`sign_up`)
     - 발생 위치: `AuthProvider`의 `signUp` 메서드
     - 파라미터:
       - `sign_up_method`: 회원가입 방법 (현재 `email`만 사용)
       - `timestamp`: 이벤트 발생 시간

### 로그 확인 방법

1. **Firebase Console**

   - [Firebase Console](https://console.firebase.google.com/)에 접속
   - 프로젝트 선택
   - 좌측 메뉴에서 "Analytics" 선택
   - "Events" 탭에서 각 이벤트별 통계 확인 가능

2. **BigQuery 연동**

   - Firebase Console에서 BigQuery 연동 설정
   - BigQuery에서 SQL 쿼리를 사용하여 상세 데이터 분석 가능
   - 예시 쿼리:

     ```sql
     -- 페이지 이동 패턴 분석
     SELECT
       from_page,
       to_page,
       COUNT(*) as count
     FROM `project.dataset.events_*`
     WHERE event_name = 'page_navigation'
     GROUP BY from_page, to_page
     ORDER BY count DESC;

     -- 타이머 사용 패턴 분석
     SELECT
       timer_type,
       AVG(duration) as avg_duration,
       COUNT(*) as count
     FROM `project.dataset.events_*`
     WHERE event_name = 'timer_save'
     GROUP BY timer_type;

     -- 로그인 방법 분석
     SELECT
       login_method,
       COUNT(*) as count
     FROM `project.dataset.events_*`
     WHERE event_name = 'login'
     GROUP BY login_method;
     ```

### 주요 분석 지표

1. **사용자 행동 분석**

   - 가장 많이 방문하는 페이지
   - 페이지 간 이동 패턴
   - 타이머 사용 빈도와 평균 지속 시간
   - 로그인 방법 선호도

2. **사용자 경험 최적화**

   - 페이지 이동 경로 분석
   - 타이머 사용 패턴
   - 기능 접근성 평가

3. **성능 모니터링**
   - 이벤트 발생 시간 분석
   - 사용자 세션 지속 시간
   - 기능별 사용 빈도
