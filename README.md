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
