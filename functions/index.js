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
    async (event) => {
        const today = new Date();
        today.setDate(today.getDate() - 1);
        const dateKey = today.toISOString().split("T")[0];
        const yearMonth = dateKey.substring(0, 7);

        const usersSnapshot = await db.collection("studyRecords").get();
        let leaderboardData = {};

        for (const userDoc of usersSnapshot.docs) {
            const userId = userDoc.id;
            const studyRecordsRef = db.collection(`studyRecords/${userId}/${yearMonth}`);
            const querySnapshot = await studyRecordsRef.where("dateKey", "==", dateKey).get();

            let totalElapsedTime = 0;
            querySnapshot.forEach((doc) => {
                totalElapsedTime += doc.data().elapsedTime || 0;
            });

            if (totalElapsedTime > 0) {
                leaderboardData[userId] = totalElapsedTime;
            }
        }

        if (Object.keys(leaderboardData).length > 0) {
            await db.collection("Leaderboard").doc(dateKey).set(leaderboardData);
            console.log(`리더보드 업데이트 완료: ${dateKey}`);
        } else {
            console.log(`리더보드 업데이트 실패: ${dateKey}에 데이터 없음`);
        }
    }
);