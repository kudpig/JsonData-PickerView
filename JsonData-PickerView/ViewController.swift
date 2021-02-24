//
//  ViewController.swift
//  JsonData-PickerView
//
//  Created by Shinichiro Kudo on 2021/02/24.
//

import UIKit


struct Country: Decodable {
    let name: String
}


class ViewController: UIViewController {

    @IBOutlet weak var displayLable: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // URLの取得
        let url = URL(string: "https://restcountries.eu/rest/v2/all")!
        
        // 元の形 .dataTask(with: url, completionHandler: (Data?, URLResponse?, Error?) -> Void)
        // クロージャの省略形。.dataTaskの引数に"url"と(完了後の)"処理"の２つを渡している。処理は３つの入力(受取)で戻り値はなし
        // sharedはシングルトンのURLSessionインスタンス。データの取得をする基本的な形。キャッシュなどのカスタマイズしたり、バックグラウンドでの取得など、特殊な場合は別のメソッドを使う
        // dataTaskはDataオブジェクトを経由してデータの送受信を行うメソッド
        // completionHandlerを指定し、サーバからのレスポンスをその場で処理する サーバから入力、引数名はdata: Data?, response: URLResponse?, error: Error?
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // errorが返ってきていない=dataを受け取れている
            if error == nil {
                // Summaryによるとdecodeメソッドはエラーを返す可能性がある(throwsの記載がある)のでdo try catchでエラーハンドリングを行う
                do {
                    // 受け取ったdataをJSONDecoder()のdecodeメソッドでswiftの形式に変換(struct) 変換先は配列型なので[Country].selfとしている
                    self.countries = try JSONDecoder().decode([Country].self, from: data!)
                } catch {
                    print("Parse Error")
                }
                print(self.countries.count) //?クロージャでの明示的なselfとは
            }
            
        
        }.resume() // 処理を開始するにはこのメソッドが必要
        
    }


}

