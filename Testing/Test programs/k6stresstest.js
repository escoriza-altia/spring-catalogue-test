import http from 'k6/http';
import { check, group, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '5m', target: 100 }, // simulate ramp-up of traffic from 1 to 100 users over 5 minutes.
    { duration: '10m', target: 100 }, // stay at 100 users for 10 minutes
    { duration: '5m', target: 0 }, // ramp-down to 0 users
  ],
  thresholds: {
    'http_req_duration': ['p(99)<1500'], // 99% of requests must complete below 1.5s
  },
};

const BASE_URL = "http://52.31.1.28:8080/complex"; // http://{publicvECSvIP}:{activated Port in security group}/complex

export default function () {
    const id = [];
    for (let index = 0; index < 10; index++) {
      const postRes = http.post(BASE_URL,'Java,Behm,Schehm,1,2,3');
      var s = postRes.body.substring(8).split(",")[0].split("=")[1];
      check(postRes, {'post is fine': (r) => r.status == 201 || r.status == 200});
      id[index] = parseInt(s);
    }
    for (let index = 0; index < 10; index++) {
      const res = http.get(BASE_URL);
      check(res, { 'get is fine': (r) => r.status == 200 });
    }
    for (let index = 0; index < 10; index++) {
      const res = http.del(BASE_URL, JSON.stringify(id[index]));
      check(res, { 'delete is fine': (r) => r.status == 204 || r.status == 200});
    }
    sleep(1);
  }
