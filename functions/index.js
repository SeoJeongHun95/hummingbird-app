/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.dailyLeaderboardUpdate = onSchedule(
    {
        schedule: "0 6 * * *", // 매일 오전 6시 실행
        timeZone: "Asia/Seoul", // 한국 시간 기준
    },
    async () => {
        console.log("🔥 리더보드 업데이트 시작");

        // 한국 시간(KST) 기준으로 어제 날짜를 가져오기
        const now = new Date();
        now.setUTCHours(now.getUTCHours() + 9); // UTC -> KST 변환
        now.setDate(now.getDate() - 1); // 어제 날짜로 설정
        const dateKey = now.toISOString().split("T")[0]; // YYYY-MM-DD 형식
        const yearMonth = dateKey.substring(0, 7); // YYYY-MM 형식

        console.log(`📅 어제 날짜: ${dateKey}, 연-월: ${yearMonth}`);

        // 모든 사용자 가져오기
        const usersSnapshot = await db.collection("studyRecords").listDocuments();
        let leaderboardData = [];

        // 각 사용자별로 어제의 데이터를 조회하여 총 elapsedTime 계산
        for (const userDoc of usersSnapshot) {
            const userId = userDoc.id;
            const studyRecordsRef = db
                .collection("studyRecords")
                .doc(userId)
                .collection(yearMonth);

            const querySnapshot = await studyRecordsRef
                .where("dateKey", "==", dateKey)
                .get();

            let totalElapsedTime = 0;
            querySnapshot.forEach((doc) => {
                totalElapsedTime += doc.data().elapsedTime || 0;
            });

            // 총 elapsedTime이 0보다 크면 리더보드에 추가
            if (totalElapsedTime > 0) {
                leaderboardData.push({ userId, totalElapsedTime });
            }
        }

        // totalElapsedTime이 높은 순으로 정렬
        leaderboardData.sort((a, b) => b.totalElapsedTime - a.totalElapsedTime);

        // 리더보드 업데이트
        if (leaderboardData.length > 0) {
            const sortedLeaderboard = {};
            leaderboardData.forEach((entry, index) => {
                sortedLeaderboard[`rank_${index + 1}`] = {
                    userId: entry.userId,
                    totalElapsedTime: entry.totalElapsedTime,
                };
            });

            await db.collection("Leaderboard").doc(dateKey).set(sortedLeaderboard);
            console.log(`✅ 리더보드 업데이트 완료: ${dateKey}`);
        } else {
            console.log(`⚠️ 리더보드 업데이트 실패: ${dateKey}에 데이터 없음`);
        }
    }
);