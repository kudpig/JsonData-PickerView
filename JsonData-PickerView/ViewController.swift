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


class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var displayLable: UILabel!

    @IBOutlet weak var pickerView: UIPickerView!
    
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
                
                // データを取得できたらUIをリロードする
                // DispatchQueueは一つ以上のタスクを管理するクラス
                // UIの読込処理はメインスレッドで行う必要があるようなので、mainメソッドにてメインキューに処理を登録する
                // asyncメソッドは、キューに処理を登録したスレッドが登録した処理が完了するのを「待たない」 要するに非同期処理ということ
                DispatchQueue.main.async {
                    // reloadComponent...UIPickerViewクラスのメソッド。列を指定してpickerを更新する
                    self.pickerView.reloadComponent(0)
                }
            }
            
        }.resume() // 処理を開始するにはこのメソッドが必要
        
    }

    // PickerView methods
    // 列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 行の数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    // rowsに表示する配列の設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name
    }
    
    // delegate method
    // rowが選択された時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = countries[row].name
        displayLable.text = selectedCountry
    }
}

